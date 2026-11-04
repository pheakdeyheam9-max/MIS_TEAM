import 'package:flutter/material.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/app_card.dart';

class LocationsScreen extends StatelessWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locations = [
      {
        'titleKey': 'sample.facility.hq_title',
        'addressKey': 'sample.facility.hq_address',
        'typeKey': 'facility_type.main_office',
        'statusKey': 'status.geofence_active',
      },
      {
        'titleKey': 'sample.facility.north_tech_title',
        'addressKey': 'sample.facility.north_tech_address',
        'typeKey': 'facility_type.regional_office',
        'statusKey': 'status.geofence_active',
      },
      {
        'titleKey': 'sample.facility.western_ops_title',
        'addressKey': 'sample.facility.western_ops_address',
        'typeKey': 'facility_type.field_operations',
        'statusKey': 'status.geofence_active',
      },
      {
        'titleKey': 'sample.facility.warehouse_title',
        'addressKey': 'sample.facility.warehouse_address',
        'typeKey': 'facility_type.warehouse',
        'statusKey': 'status.geofence_active',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: Text('locations.app_bar_title'.tr(context))),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MaxWidthContainer(
          maxWidth: 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'locations.heading'.tr(context),
                style: AppTypography.headingLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'locations.subtitle'.tr(context),
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  final loc = locations[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppCard(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: AppColors.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc['titleKey']!.tr(context),
                                  style: AppTypography.headingSmall,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  loc['addressKey']!.tr(context),
                                  style: AppTypography.bodySmall,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceVariant,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        loc['typeKey']!.tr(context),
                                        style: AppTypography.caption,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.successBackground,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        loc['statusKey']!.tr(context),
                                        style: AppTypography.caption.copyWith(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
    );
  }
}
