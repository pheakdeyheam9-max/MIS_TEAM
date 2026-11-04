import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../domain/entities/employee_entity.dart';
import '../features/employees/bindings/employee_binding.dart';
import '../features/employees/screens/employee_form_screen.dart';
import '../features/employees/screens/employee_list_screen.dart';
import '../features/products/bindings/product_binding.dart';
import '../features/products/screens/product_list_screen.dart';
import '../shared/widgets/main_shell.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/reset_password_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/missions/screens/mission_types_screen.dart';
import '../features/missions/screens/mission_list_screen.dart';
import '../features/missions/screens/mission_request_screen.dart';
import '../features/requests_hub/screens/requests_hub_screen.dart';
import '../features/leaves/screens/leave_types_screen.dart';
import '../features/leaves/screens/leave_list_screen.dart';
import '../features/leaves/screens/leave_request_screen.dart';
import '../features/schedule/screens/schedule_screen.dart';
import '../features/schedule/screens/calendar_screen.dart';
import '../features/attendance/screens/attendance_check_in_screen.dart';
import '../features/attendance/screens/attendance_check_out_screen.dart';
import '../features/locations/screens/locations_screen.dart';
import '../features/more/screens/more_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/screens/edit_profile_screen.dart';
import '../features/profile/screens/change_password_screen.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case AppRoutes.mainShell:
        final initialTab = (settings.arguments as int?) ?? 0;
        return MaterialPageRoute(
          builder: (_) => MainShellScreen(initialTab: initialTab),
        );
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case AppRoutes.requestsHub:
        return MaterialPageRoute(builder: (_) => const RequestsHubScreen());
      case AppRoutes.missionTypes:
        return MaterialPageRoute(builder: (_) => const MissionTypesScreen());
      case AppRoutes.missionList:
        return MaterialPageRoute(builder: (_) => const MissionListScreen());
      case AppRoutes.newMissionRequest:
        return MaterialPageRoute(builder: (_) => const MissionRequestScreen());
      case AppRoutes.leaveTypes:
        return MaterialPageRoute(builder: (_) => const LeaveTypesScreen());
      case AppRoutes.leaveList:
        return MaterialPageRoute(builder: (_) => const LeaveListScreen());
      case AppRoutes.newLeaveRequest:
        return MaterialPageRoute(builder: (_) => const LeaveRequestScreen());
      case AppRoutes.schedule:
        return MaterialPageRoute(builder: (_) => const ScheduleScreen());
      case AppRoutes.calendar:
        return MaterialPageRoute(builder: (_) => const CalendarScreen());
      case AppRoutes.attendanceCheckIn:
        return MaterialPageRoute(
          builder: (_) => const AttendanceCheckInScreen(),
        );
      case AppRoutes.attendanceCheckOut:
        return MaterialPageRoute(
          builder: (_) => const AttendanceCheckOutScreen(),
        );
      case AppRoutes.locations:
        return MaterialPageRoute(builder: (_) => const LocationsScreen());
      case AppRoutes.more:
        return MaterialPageRoute(builder: (_) => const MoreScreen());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case AppRoutes.changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case AppRoutes.productList:
        ProductBinding().dependencies();
        return MaterialPageRoute(builder: (_) => const ProductListScreen());
      case AppRoutes.employeeList:
        EmployeeBinding().dependencies();
        return MaterialPageRoute(builder: (_) => const EmployeeListScreen());
      case AppRoutes.employeeForm:
        EmployeeBinding().dependencies();
        final employee = settings.arguments as EmployeeEntity?;
        return MaterialPageRoute(
          builder: (_) => EmployeeFormScreen(employee: employee),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
