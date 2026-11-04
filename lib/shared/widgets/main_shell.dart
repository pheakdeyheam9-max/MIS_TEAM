import 'package:flutter/material.dart';
import '../../core/localization/localize_key.dart';
import '../../core/theme/app_colors.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/requests_hub/screens/requests_hub_screen.dart';
import '../../features/attendance/screens/attendance_check_in_screen.dart';
import '../../features/schedule/screens/calendar_screen.dart';
import '../../features/more/screens/more_screen.dart';

class MainShellScreen extends StatefulWidget {
  final int initialTab;

  const MainShellScreen({super.key, this.initialTab = 0});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  void didUpdateWidget(MainShellScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTab != oldWidget.initialTab) {
      setState(() {
        _currentIndex = widget.initialTab;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const DashboardScreen(),
      const RequestsHubScreen(),
      const AttendanceCheckInScreen(),
      CalendarScreen(isTabActive: _currentIndex == 3),
      const MoreScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            activeIcon: const Icon(Icons.dashboard),
            label: 'nav.dashboard'.tr(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment_outlined),
            activeIcon: const Icon(Icons.assignment),
            label: 'nav.requests'.tr(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.how_to_reg_outlined),
            activeIcon: const Icon(Icons.how_to_reg),
            label: 'nav.attendance'.tr(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            activeIcon: const Icon(Icons.calendar_month),
            label: 'nav.calendar'.tr(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.more_horiz_outlined),
            activeIcon: const Icon(Icons.more_horiz),
            label: 'nav.more'.tr(context),
          ),
        ],
      ),
    );
  }
}
