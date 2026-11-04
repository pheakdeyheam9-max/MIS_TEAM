import 'package:flutter/material.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/state/user_notifier.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../navigation/app_routes.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserEntity>(
      valueListenable: UserNotifier.userNotifier,
      builder: (context, user, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('profile.app_bar_title'.tr(context)),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.editProfile),
              ),
            ],
          ),
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: MaxWidthContainer(
              maxWidth: 800,
              child: Column(
                children: [
                  _buildAvatarCard(context, user),
                  const SizedBox(height: 20),
                  _buildDetailsCard(context, user),
                  const SizedBox(height: 20),
                  _buildActions(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarCard(BuildContext context, UserEntity user) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: AppColors.primary,
            child: Text(
              user.initials,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(user.name, style: AppTypography.headingLarge),
          const SizedBox(height: 4),
          Text(
            user.role.isNotEmpty
                ? user.role
                : 'dashboard.header.role'.tr(context),
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.successBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'status.active_employee'.tr(context),
              style: AppTypography.caption.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, UserEntity user) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'profile.section.credentials'.tr(context),
            style: AppTypography.headingMedium,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.badge_outlined,
            'profile.field.employee_id'.tr(context),
            user.employeeId.isNotEmpty ? user.employeeId : 'EMP-9824',
          ),
          const Divider(),
          _buildInfoRow(
            Icons.email_outlined,
            'profile.field.email_address'.tr(context),
            user.email,
          ),
          const Divider(),
          _buildInfoRow(
            Icons.phone_outlined,
            'profile.field.phone_number'.tr(context),
            user.phoneNumber.isNotEmpty ? user.phoneNumber : 'N/A',
          ),
          const Divider(),
          _buildInfoRow(
            Icons.business_outlined,
            'profile.field.department'.tr(context),
            user.department.isNotEmpty
                ? user.department
                : 'Engineering & Operations',
          ),
          const Divider(),
          _buildInfoRow(
            Icons.location_on_outlined,
            'profile.field.assigned_facility'.tr(context),
            'sample.facility.hq_bldg_a'.tr(context),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.caption),
                Text(
                  val,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        AppButton(
          text: 'profile.btn_edit_profile'.tr(context),
          icon: Icons.edit,
          onPressed: () => Navigator.pushNamed(context, AppRoutes.editProfile),
        ),
        const SizedBox(height: 12),
        AppButton(
          text: 'profile.btn_change_password'.tr(context),
          variant: AppButtonVariant.outline,
          icon: Icons.lock_outline,
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.changePassword),
        ),
      ],
    );
  }
}
