import 'package:flutter/material.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/state/attendance_notifier.dart';
import '../../../core/state/user_notifier.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../navigation/app_routes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../../../shared/widgets/language_selector_dialog.dart';
import '../../../shared/widgets/status_badge.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('dashboard.app_bar_title'.tr(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: 'more.item.language'.tr(context),
            onPressed: () {
              LanguageSelectorDialog.show(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.notifications);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MaxWidthContainer(
          maxWidth: 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(context),
              const SizedBox(height: 20),
              _buildQuickActionsGrid(context),
              const SizedBox(height: 20),
              _buildAttendanceOverview(context),
              const SizedBox(height: 20),
              _buildRecentMissions(context),
              const SizedBox(height: 20),
              _buildRecentLeaves(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return ValueListenableBuilder<UserEntity>(
      valueListenable: UserNotifier.userNotifier,
      builder: (context, user, child) {
        return AppCard(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Text(
                  user.initials,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'dashboard.header.greeting_subtitle'.tr(context),
                      style: AppTypography.caption.copyWith(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.name,
                      style: AppTypography.headingLarge.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.role.isNotEmpty
                          ? user.role
                          : 'dashboard.header.role'.tr(context),
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    final actions = [
      {
        'title': 'dashboard.action.requests_hub'.tr(context),
        'icon': Icons.assignment_outlined,
        'route': AppRoutes.requestsHub,
      },
      {
        'title': 'dashboard.action.check_in'.tr(context),
        'icon': Icons.how_to_reg,
        'route': AppRoutes.attendanceCheckIn,
      },
      {
        'title': 'dashboard.action.new_mission'.tr(context),
        'icon': Icons.flight_takeoff,
        'route': AppRoutes.newMissionRequest,
      },
      {
        'title': 'dashboard.action.new_leave'.tr(context),
        'icon': Icons.beach_access,
        'route': AppRoutes.newLeaveRequest,
      },
      {
        'title': 'dashboard.action.products'.tr(context),
        'icon': Icons.inventory_2_outlined,
        'route': AppRoutes.productList,
      },
      {
        'title': 'dashboard.action.employees'.tr(context),
        'icon': Icons.badge_outlined,
        'route': AppRoutes.employeeList,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'dashboard.section.quick_actions'.tr(context),
          style: AppTypography.headingMedium,
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveLayout.isTablet(context) ? 4 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final item = actions[index];
            return AppCard(
              onTap: () {
                Navigator.pushNamed(context, item['route'] as String);
              },
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item['title'] as String,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAttendanceOverview(BuildContext context) {
    return ValueListenableBuilder<AttendanceRecordState>(
      valueListenable: AttendanceNotifier.attendanceNotifier,
      builder: (context, state, child) {
        String statusLabel;
        String checkInText = '--:--';
        String checkOutText = '--:--';

        if (state.checkInTime != null) {
          final dt = state.checkInTime!;
          final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
          final period = dt.hour >= 12 ? 'PM' : 'AM';
          checkInText =
              '${hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} $period';
        }

        if (state.checkOutTime != null) {
          final dt = state.checkOutTime!;
          final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
          final period = dt.hour >= 12 ? 'PM' : 'AM';
          checkOutText =
              '${hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} $period';
        }

        if (state.status == AttendanceStateStatus.notCheckedIn) {
          statusLabel = 'attendance.status.not_checked_in'.tr(context);
        } else if (state.status == AttendanceStateStatus.working) {
          statusLabel = 'attendance.status.working'.tr(context);
        } else {
          statusLabel = 'attendance.status.shift_completed'.tr(context);
        }

        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'dashboard.attendance.heading'.tr(context),
                    style: AppTypography.headingMedium,
                  ),
                  StatusBadge(status: statusLabel),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildAttendanceItem(
                      'dashboard.attendance.check_in_label'.tr(context),
                      checkInText,
                      Icons.login_outlined,
                      AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildAttendanceItem(
                      'dashboard.attendance.check_out_label'.tr(context),
                      state.status == AttendanceStateStatus.working
                          ? state.formattedDuration
                          : checkOutText,
                      Icons.logout_outlined,
                      AppColors.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (state.status == AttendanceStateStatus.notCheckedIn) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.attendanceCheckIn,
                    ),
                    icon: const Icon(Icons.login, size: 18),
                    label: Text(
                      'dashboard.attendance.btn_check_in_now'.tr(context),
                    ),
                  ),
                ),
              ] else if (state.status == AttendanceStateStatus.working) ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.attendanceCheckOut,
                    ),
                    icon: const Icon(Icons.logout, size: 18),
                    label: Text(
                      'dashboard.attendance.btn_check_out_now'.tr(context),
                    ),
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '${'status.completed'.tr(context)} • ${state.formattedDuration}',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendanceItem(
    String label,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.caption),
                Text(
                  time,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMissions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'dashboard.missions.heading'.tr(context),
              style: AppTypography.headingMedium,
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.missionList),
              child: Text('common.view_all'.tr(context)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AppCard(
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.business, color: AppColors.primary),
                ),
                title: Text(
                  'sample.mission.datacenter_title'.tr(context),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'sample.mission.datacenter_subtitle'.tr(context),
                ),
                trailing: const StatusBadge(status: 'Approved'),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.assignment_turned_in,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  'sample.mission.fiber_title'.tr(context),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('sample.mission.fiber_subtitle'.tr(context)),
                trailing: const StatusBadge(status: 'Pending'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentLeaves(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'dashboard.leaves.heading'.tr(context),
              style: AppTypography.headingMedium,
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.leaveList),
              child: Text('common.view_all'.tr(context)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AppCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.beach_access, color: AppColors.accent),
            ),
            title: Text(
              'sample.leave.annual_title'.tr(context),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('sample.leave.annual_subtitle'.tr(context)),
            trailing: const StatusBadge(status: 'Approved'),
          ),
        ),
      ],
    );
  }
}
