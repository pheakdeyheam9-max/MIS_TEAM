import 'package:flutter/material.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../navigation/app_routes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_drawer.dart';

class RequestsHubScreen extends StatelessWidget {
  const RequestsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('requests_hub.app_bar_title'.tr(context))),
      drawer: const AppDrawer(),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MaxWidthContainer(
          maxWidth: 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'requests_hub.heading'.tr(context),
                style: AppTypography.headingLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'requests_hub.subtitle'.tr(context),
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24),
              _buildCategoryCard(
                context,
                title: 'requests_hub.category.missions.title'.tr(context),
                subtitle: 'requests_hub.category.missions.subtitle'.tr(context),
                icon: Icons.flight_takeoff,
                onPrimaryTap: () =>
                    Navigator.pushNamed(context, AppRoutes.missionTypes),
                onSecondaryTap: () =>
                    Navigator.pushNamed(context, AppRoutes.newMissionRequest),
                primaryLabel: 'requests_hub.category.missions.btn_types'.tr(
                  context,
                ),
                secondaryLabel: 'requests_hub.category.missions.btn_new'.tr(
                  context,
                ),
              ),
              const SizedBox(height: 20),
              _buildCategoryCard(
                context,
                title: 'requests_hub.category.leaves.title'.tr(context),
                subtitle: 'requests_hub.category.leaves.subtitle'.tr(context),
                icon: Icons.beach_access,
                onPrimaryTap: () =>
                    Navigator.pushNamed(context, AppRoutes.leaveTypes),
                onSecondaryTap: () =>
                    Navigator.pushNamed(context, AppRoutes.newLeaveRequest),
                primaryLabel: 'requests_hub.category.leaves.btn_types'.tr(
                  context,
                ),
                secondaryLabel: 'requests_hub.category.leaves.btn_new'.tr(
                  context,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPrimaryTap,
    required VoidCallback onSecondaryTap,
    required String primaryLabel,
    required String secondaryLabel,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.headingMedium),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTypography.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onPrimaryTap,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(primaryLabel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onSecondaryTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(secondaryLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
