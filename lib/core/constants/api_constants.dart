import 'package:flutter/foundation.dart';

class ApiConstants {
  ApiConstants._();

  // Configurable API Base URL
  static String get baseUrl {
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) return envUrl;
    if (kIsWeb) return 'http://localhost:33033/api';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:33033/api';
    }
    return 'http://localhost:33033/api';
  }

  // Endpoints (API-ready declarations)
  static const String login = '/auth/login';
  static const String me = '/auth/me';
  static const String logout = '/auth/logout';
  static const String resetPassword = '/auth/reset-password';
  static const String userProfile = '/user/profile';
  static const String changePassword = '/user/change-password';

  static const String missions = '/missions';
  static const String missionTypes = '/missions/types';

  static const String leaves = '/leaves';
  static const String leaveTypes = '/leaves/types';

  static const String attendance = '/attendance';
  static const String attendanceCheckIn = '/attendance/check-in';
  static const String attendanceCheckOut = '/attendance/check-out';

  static const String notifications = '/notifications';
  static const String schedule = '/schedule';
  static const String locations = '/locations';

  static const String products = '/products';
  static const String employees = '/employees';
}
