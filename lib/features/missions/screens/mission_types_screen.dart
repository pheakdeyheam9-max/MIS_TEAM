import 'package:flutter/material.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../navigation/app_routes.dart';
import '../../../shared/widgets/app_card.dart';

class MissionTypesScreen extends StatelessWidget {
  const MissionTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final types = [
      {
        'id': 'mt-1',
        'title': 'mission_type.client_site_inspection.title'.tr(context),
        'description': 'mission_type.client_site_inspection.desc'.tr(context),
        'icon': Icons.business_outlined,
      },
      {
        'id': 'mt-2',
        'title': 'mission_type.field_audit.title'.tr(context),
        'description': 'mission_type.field_audit.desc'.tr(context),
        'icon': Icons.assignment_turned_in_outlined,
      },
      {
        'id': 'mt-3',
        'title': 'mission_type.technical_support.title'.tr(context),
        'description': 'mission_type.technical_support.desc'.tr(context),
        'icon': Icons.build_outlined,
      },
      {
        'id': 'mt-4',
        'title': 'mission_type.partner_training.title'.tr(context),
        'description': 'mission_type.partner_training.desc'.tr(context),
        'icon': Icons.school_outlined,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: Text('mission_types.app_bar_title'.tr(context))),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MaxWidthContainer(
          maxWidth: 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'mission_types.heading'.tr(context),
                style: AppTypography.headingLarge,
              ),
              const SizedBox(height: 6),
              Text(
                'mission_types.description'.tr(context),
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: types.length,
                itemBuilder: (context, index) {
                  final item = types[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppCard(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.missionList);
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              item['icon'] as IconData,
                              size: 28,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] as String,
                                  style: AppTypography.headingSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['description'] as String,
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColors.textMuted,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.newMissionRequest);
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text('mission_types.fab_new_mission'.tr(context)),
      ),
    );
  }
}
