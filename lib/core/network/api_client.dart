import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../storage/local_storage.dart';

enum ApiStatus { success, error, loading }

class ApiResult<T> {
  final ApiStatus status;
  final T? data;
  final String? errorMessage;
  final int? statusCode;

  const ApiResult({
    required this.status,
    this.data,
    this.errorMessage,
    this.statusCode,
  });

  factory ApiResult.success(T data) {
    return ApiResult(status: ApiStatus.success, data: data);
  }

  factory ApiResult.error(String message, {int? code}) {
    return ApiResult(
      status: ApiStatus.error,
      errorMessage: message,
      statusCode: code,
    );
  }

  bool get isSuccess => status == ApiStatus.success;
  bool get isError => status == ApiStatus.error;
}

abstract class ApiClient {
  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic data)? jsonParser,
  });

  Future<ApiResult<T>> post<T>(
    String path, {
    dynamic body,
    Map<String, String>? headers,
    T Function(dynamic data)? jsonParser,
  });

  Future<ApiResult<T>> put<T>(
    String path, {
    dynamic body,
    Map<String, String>? headers,
    T Function(dynamic data)? jsonParser,
  });

  Future<ApiResult<T>> delete<T>(
    String path, {
    Map<String, String>? headers,
    T Function(dynamic data)? jsonParser,
  });
}

class HttpApiClient implements ApiClient {
  final String baseUrl;
  final LocalStorageService storage;
  final http.Client client;

  HttpApiClient({String? baseUrl, required this.storage, http.Client? client})
    : baseUrl = baseUrl ?? ApiConstants.baseUrl,
      client = client ?? http.Client();

  Future<Map<String, String>> _buildHeaders(
    Map<String, String>? customHeaders,
  ) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = await storage.getString(LocalStorageService.keyJwtToken);
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    return headers;
  }

  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    final fullPath = path.startsWith('http') ? path : '$baseUrl$path';
    final uri = Uri.parse(fullPath);
    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }
    final stringParams = queryParameters.map(
      (k, v) => MapEntry(k, v.toString()),
    );
    return uri.replace(queryParameters: stringParams);
  }

  ApiResult<T> _processResponse<T>(
    http.Response response,
    T Function(dynamic data)? jsonParser,
  ) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        if (jsonParser != null) {
          return ApiResult.success(jsonParser(null));
        }
        return ApiResult.success(null as T);
      }
      try {
        final decoded = json.decode(response.body);
        final data = jsonParser != null ? jsonParser(decoded) : decoded as T;
        return ApiResult.success(data);
      } catch (e) {
        debugPrint('JSON parse error: $e');
        return ApiResult.error('Failed to parse server response.');
      }
    } else if (response.statusCode == 401) {
      return ApiResult.error(
        'Unauthorized access. Session expired or token invalid.',
        code: 401,
      );
    } else if (response.statusCode == 403) {
      return ApiResult.error(
        'Forbidden. You do not have permission to perform this action.',
        code: 403,
      );
    } else {
      String msg = 'Request failed with status code ${response.statusCode}';
      try {
        final decoded = json.decode(response.body);
        if (decoded is Map && decoded.containsKey('message')) {
          msg = decoded['message'].toString();
        }
      } catch (_) {}
      return ApiResult.error(msg, code: response.statusCode);
    }
  }

  @override
  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic data)? jsonParser,
  }) async {
    try {
      final reqHeaders = await _buildHeaders(headers);
      final uri = _buildUri(path, queryParameters);
      final response = await client.get(uri, headers: reqHeaders);
      return _processResponse<T>(response, jsonParser);
    } catch (e) {
      debugPrint('HttpApiClient GET Error: $e');
      return ApiResult.error('Network error. Please check your connection.');
    }
  }

  @override
  Future<ApiResult<T>> post<T>(
    String path, {
    dynamic body,
    Map<String, String>? headers,
    T Function(dynamic data)? jsonParser,
  }) async {
    try {
      final reqHeaders = await _buildHeaders(headers);
      final uri = _buildUri(path);
      final encodedBody = body is String ? body : json.encode(body);
      final response = await client.post(
        uri,
        headers: reqHeaders,
        body: encodedBody,
      );
      return _processResponse<T>(response, jsonParser);
    } catch (e) {
      debugPrint('HttpApiClient POST Error: $e');
      return ApiResult.error('Network error. Please check your connection.');
    }
  }

  @override
  Future<ApiResult<T>> put<T>(
    String path, {
    dynamic body,
    Map<String, String>? headers,
    T Function(dynamic data)? jsonParser,
  }) async {
    try {
      final reqHeaders = await _buildHeaders(headers);
      final uri = _buildUri(path);
      final encodedBody = body is String ? body : json.encode(body);
      final response = await client.put(
        uri,
        headers: reqHeaders,
        body: encodedBody,
      );
      return _processResponse<T>(response, jsonParser);
    } catch (e) {
      debugPrint('HttpApiClient PUT Error: $e');
      return ApiResult.error('Network error. Please check your connection.');
    }
  }

  @override
  Future<ApiResult<T>> delete<T>(
    String path, {
    Map<String, String>? headers,
    T Function(dynamic data)? jsonParser,
  }) async {
    try {
      final reqHeaders = await _buildHeaders(headers);
      final uri = _buildUri(path);
      final response = await client.delete(uri, headers: reqHeaders);
      return _processResponse<T>(response, jsonParser);
    } catch (e) {
      debugPrint('HttpApiClient DELETE Error: $e');
      return ApiResult.error('Network error. Please check your connection.');
    }
  }
}

class MockApiClient implements ApiClient {
  @override
  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic data)? jsonParser,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResult.error(
      'Mock client: Connect backend API to fetch real data',
    );
  }

  @override
  Future<ApiResult<T>> post<T>(
    String path, {
    dynamic body,
    Map<String, String>? headers,
    T Function(dynamic data)? jsonParser,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResult.error(
      'Mock client: Connect backend API to execute operation',
    );
  }

  @override
  Future<ApiResult<T>> put<T>(
    String path, {
    dynamic body,
    Map<String, String>? headers,
    T Function(dynamic data)? jsonParser,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResult.error('Mock client: Connect backend API to update data');
  }

  @override
  Future<ApiResult<T>> delete<T>(
    String path, {
    Map<String, String>? headers,
    T Function(dynamic data)? jsonParser,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResult.error('Mock client: Connect backend API to delete data');
  }
}
