import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageService {
  static const String keyJwtToken = 'jwt_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserData = 'user_data';

  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> saveBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

class SharedPreferencesLocalStorageService implements LocalStorageService {
  SharedPreferences? _prefs;
  final Map<String, dynamic> _memoryFallback = {};

  Future<SharedPreferences?> _getPrefs() async {
    if (_prefs != null) return _prefs;
    try {
      _prefs = await SharedPreferences.getInstance();
      return _prefs;
    } catch (e) {
      debugPrint('SharedPreferences init error in LocalStorageService: $e');
      return null;
    }
  }

  @override
  Future<void> saveString(String key, String value) async {
    _memoryFallback[key] = value;
    final prefs = await _getPrefs();
    await prefs?.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    final prefs = await _getPrefs();
    if (prefs != null) {
      return prefs.getString(key) ?? _memoryFallback[key] as String?;
    }
    return _memoryFallback[key] as String?;
  }

  @override
  Future<void> saveBool(String key, bool value) async {
    _memoryFallback[key] = value;
    final prefs = await _getPrefs();
    await prefs?.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    final prefs = await _getPrefs();
    if (prefs != null) {
      return prefs.getBool(key) ?? _memoryFallback[key] as bool?;
    }
    return _memoryFallback[key] as bool?;
  }

  @override
  Future<void> remove(String key) async {
    _memoryFallback.remove(key);
    final prefs = await _getPrefs();
    await prefs?.remove(key);
  }

  @override
  Future<void> clear() async {
    _memoryFallback.clear();
    final prefs = await _getPrefs();
    await prefs?.clear();
  }
}

class InMemoryLocalStorage implements LocalStorageService {
  final Map<String, dynamic> _storage = {};

  @override
  Future<void> saveString(String key, String value) async {
    _storage[key] = value;
  }

  @override
  Future<String?> getString(String key) async {
    return _storage[key] as String?;
  }

  @override
  Future<void> saveBool(String key, bool value) async {
    _storage[key] = value;
  }

  @override
  Future<bool?> getBool(String key) async {
    return _storage[key] as bool?;
  }

  @override
  Future<void> remove(String key) async {
    _storage.remove(key);
  }

  @override
  Future<void> clear() async {
    _storage.clear();
  }
}
