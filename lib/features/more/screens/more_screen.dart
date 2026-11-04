import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import '../../../core/localization/app_localization.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/state/user_notifier.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../navigation/app_routes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../../../shared/widgets/language_selector_dialog.dart';
import '../../auth/controllers/auth_controller.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = AppLocalization.localeNotifier.value;
    final currentLangLabel = currentLocale.languageCode == 'km'
        ? '🇰🇭 ភាសាខ្មែរ'
        : '🇺🇸 English';

    return Scaffold(
      appBar: AppBar(title: Text('more.app_bar_title'.tr(context))),
      drawer: const AppDrawer(),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MaxWidthContainer(
          maxWidth: 800,
          child: Column(
            children: [
              _buildProfileHeader(context),
              const SizedBox(height: 20),
              _buildSectionTitle('more.section.settings'.tr(context)),
              AppCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.language, color: AppColors.primary),
                  title: Text(
                    'more.item.language'.tr(context),
                    style: AppTypography.bodyLarge,
                  ),
                  subtitle: Text(
                    currentLangLabel,
                    style: AppTypography.bodySmall,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                  onTap: () => LanguageSelectorDialog.show(context),
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('more.section.account_profile'.tr(context)),
              _buildMenuCard(context, [
                _MenuItem(
                  'more.item.user_profile'.tr(context),
                  Icons.person_outline,
                  AppRoutes.profile,
                ),
                _MenuItem(
                  'more.item.edit_profile'.tr(context),
                  Icons.edit_outlined,
                  AppRoutes.editProfile,
                ),
                _MenuItem(
                  'more.item.change_password'.tr(context),
                  Icons.lock_outline,
                  AppRoutes.changePassword,
                ),
              ]),
              const SizedBox(height: 20),
              _buildSectionTitle('more.section.work_schedule'.tr(context)),
              _buildMenuCard(context, [
                _MenuItem(
                  'more.item.my_schedule'.tr(context),
                  Icons.schedule_outlined,
                  AppRoutes.schedule,
                ),
                _MenuItem(
                  'more.item.my_calendar'.tr(context),
                  Icons.calendar_month_outlined,
                  AppRoutes.calendar,
                ),
                _MenuItem(
                  'more.item.locations'.tr(context),
                  Icons.location_on_outlined,
                  AppRoutes.locations,
                ),
              ]),
              const SizedBox(height: 20),
              _buildSectionTitle('more.section.catalog_staff'.tr(context)),
              _buildMenuCard(context, [
                _MenuItem(
                  'more.item.product_catalog'.tr(context),
                  Icons.inventory_2_outlined,
                  AppRoutes.productList,
                ),
                _MenuItem(
                  'more.item.employee_directory'.tr(context),
                  Icons.badge_outlined,
                  AppRoutes.employeeList,
                ),
              ]),
              const SizedBox(height: 20),
              _buildSectionTitle(
                'more.section.requests_operations'.tr(context),
              ),
              _buildMenuCard(context, [
                _MenuItem(
                  'more.item.requests_hub'.tr(context),
                  Icons.assignment_outlined,
                  AppRoutes.requestsHub,
                ),
                _MenuItem(
                  'more.item.mission_categories'.tr(context),
                  Icons.flight_takeoff_outlined,
                  AppRoutes.missionTypes,
                ),
                _MenuItem(
                  'more.item.leave_categories'.tr(context),
                  Icons.beach_access_outlined,
                  AppRoutes.leaveTypes,
                ),
              ]),
              const SizedBox(height: 24),
              AppCard(
                onTap: () async {
                  if (Get.isRegistered<AuthController>()) {
                    await Get.find<AuthController>().logout();
                  }
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (r) => false,
                    );
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: AppColors.error),
                    const SizedBox(width: 8),
                    Text(
                      'more.btn_sign_out'.tr(context),
                      style: const TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return ValueListenableBuilder<UserEntity>(
      valueListenable: UserNotifier.userNotifier,
      builder: (context, user, child) {
        return AppCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary,
                child: Text(
                  user.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: AppTypography.headingMedium),
                    Text(user.email, style: AppTypography.bodySmall),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 18),
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.profile),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(
          title,
          style: AppTypography.caption.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, List<_MenuItem> items) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              ListTile(
                leading: Icon(item.icon, color: AppColors.primary),
                title: Text(item.title, style: AppTypography.bodyLarge),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textMuted,
                ),
                onTap: () => Navigator.pushNamed(context, item.route),
              ),
              if (index < items.length - 1) const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final String route;

  _MenuItem(this.title, this.icon, this.route);
}
