import 'dart:convert';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/state/user_notifier.dart';
import '../../core/storage/local_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final LocalStorageService storage;

  AuthRepositoryImpl({required this.apiClient, required this.storage});

  @override
  Future<ApiResult<UserEntity>> login(String username, String password) async {
    final apiResult = await apiClient.post<Map<String, dynamic>>(
      ApiConstants.login,
      body: {'username': username, 'password': password},
    );

    if (apiResult.isSuccess && apiResult.data != null) {
      final data = apiResult.data!;
      final token =
          data['accessToken']?.toString() ??
          data['token']?.toString() ??
          data['jwt']?.toString();

      if (token != null && token.isNotEmpty) {
        await storage.saveString(LocalStorageService.keyJwtToken, token);
      }
      final refreshToken = data['refreshToken']?.toString();
      if (refreshToken != null) {
        await storage.saveString(
          LocalStorageService.keyRefreshToken,
          refreshToken,
        );
      }
      await storage.saveBool(LocalStorageService.keyIsLoggedIn, true);

      UserEntity user = UserNotifier.currentUser;
      if (data.containsKey('user') && data['user'] is Map<String, dynamic>) {
        user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      }
      UserNotifier.updateUser(user);
      await storage.saveString(
        LocalStorageService.keyUserData,
        json.encode(UserModel.fromEntity(user).toJson()),
      );
      return ApiResult.success(user);
    }

    return ApiResult.error(
      apiResult.errorMessage ??
          'Invalid username or password. Please try again.',
    );
  }

  @override
  Future<ApiResult<bool>> resetPassword(String email) async {
    return ApiResult.error(
      'Password reset is not supported by the backend server.',
    );
  }

  @override
  Future<ApiResult<UserEntity>> getCurrentUser() async {
    final token = await storage.getString(LocalStorageService.keyJwtToken);
    final isLoggedIn =
        await storage.getBool(LocalStorageService.keyIsLoggedIn) ?? false;

    if (!isLoggedIn || token == null || token.isEmpty) {
      return ApiResult.error('No authenticated user session found.');
    }

    final result = await apiClient.get<Map<String, dynamic>>(ApiConstants.me);

    if (result.isSuccess && result.data != null) {
      final user = UserModel.fromJson(result.data!);
      UserNotifier.updateUser(user);
      await storage.saveString(
        LocalStorageService.keyUserData,
        json.encode(UserModel.fromEntity(user).toJson()),
      );
      return ApiResult.success(user);
    }

    // Session invalid or expired on server
    await logout();
    return ApiResult.error('Session expired. Please sign in again.');
  }

  @override
  Future<ApiResult<UserEntity>> updateProfile(UserEntity user) async {
    return ApiResult.error(
      'Profile update is not supported by the backend server.',
    );
  }

  @override
  Future<ApiResult<bool>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    return ApiResult.error(
      'Change password is not supported by the backend server.',
    );
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.post(ApiConstants.logout);
    } catch (_) {}
    await storage.remove(LocalStorageService.keyJwtToken);
    await storage.remove(LocalStorageService.keyRefreshToken);
    await storage.remove(LocalStorageService.keyIsLoggedIn);
    await storage.remove(LocalStorageService.keyUserData);
  }
}
