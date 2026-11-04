import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import '../../core/localization/app_localization.dart';
import '../../core/localization/localize_key.dart';
import '../../core/state/user_notifier.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/entities/user_entity.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../navigation/app_routes.dart';
import 'language_selector_dialog.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _navigateToTab(BuildContext context, int tabIndex) {
    Navigator.pop(context);
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.mainShell,
      (route) => false,
      arguments: tabIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = AppLocalization.localeNotifier.value;
    final currentLangLabel = currentLocale.languageCode == 'km'
        ? '🇰🇭 ភាសាខ្មែរ'
        : '🇺🇸 English';

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          ValueListenableBuilder<UserEntity>(
            valueListenable: UserNotifier.userNotifier,
            builder: (context, user, child) {
              return UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: AppColors.primary),
                currentAccountPicture: CircleAvatar(
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
                accountName: Text(
                  user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                accountEmail: Text(
                  user.email,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              );
            },
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.dashboard_outlined,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    'drawer.dashboard'.tr(context),
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  onTap: () => _navigateToTab(context, 0),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.assignment_outlined,
                  title: 'drawer.requests_hub'.tr(context),
                  route: AppRoutes.requestsHub,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.flight_takeoff,
                  title: 'drawer.missions'.tr(context),
                  route: AppRoutes.missionTypes,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.beach_access,
                  title: 'drawer.leaves'.tr(context),
                  route: AppRoutes.leaveTypes,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.how_to_reg,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    'drawer.attendance_check_in'.tr(context),
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  onTap: () => _navigateToTab(context, 2),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.calendar_month_outlined,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    'drawer.schedule_calendar'.tr(context),
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  onTap: () => _navigateToTab(context, 3),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.location_on_outlined,
                  title: 'drawer.locations'.tr(context),
                  route: AppRoutes.locations,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.notifications_outlined,
                  title: 'drawer.notifications'.tr(context),
                  route: AppRoutes.notifications,
                ),
                const Divider(),
                _buildMenuItem(
                  context,
                  icon: Icons.inventory_2_outlined,
                  title: 'drawer.product_catalog'.tr(context),
                  route: AppRoutes.productList,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.badge_outlined,
                  title: 'drawer.employee_directory'.tr(context),
                  route: AppRoutes.employeeList,
                ),
                const Divider(),
                _buildMenuItem(
                  context,
                  icon: Icons.person_outline,
                  title: 'drawer.user_profile'.tr(context),
                  route: AppRoutes.profile,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.lock_outline,
                  title: 'drawer.change_password'.tr(context),
                  route: AppRoutes.changePassword,
                ),
                ListTile(
                  leading: const Icon(Icons.language, color: AppColors.primary),
                  title: Text(
                    'drawer.language'.tr(context),
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  trailing: Text(
                    currentLangLabel,
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) {
                        LanguageSelectorDialog.show(context);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: Text(
              'drawer.sign_out'.tr(context),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () async {
              Navigator.pop(context);
              if (Get.isRegistered<AuthController>()) {
                await Get.find<AuthController>().logout();
              }
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    Object? arguments,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: AppTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route, arguments: arguments);
      },
    );
  }
}
