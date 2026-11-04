import 'package:flutter/material.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/app_card.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shifts = [
      {
        'dayKey': 'common.day.today',
        'date': 'Feb 24, 2025',
        'titleKey': 'sample.shift.regular_day',
        'time': '08:30 AM - 05:30 PM',
        'locationKey': 'sample.location.hq_bldg_a',
        'status': 'Active',
      },
      {
        'dayKey': 'common.day.tomorrow',
        'date': 'Feb 25, 2025',
        'titleKey': 'sample.shift.inspection',
        'time': '09:00 AM - 06:00 PM',
        'locationKey': 'sample.location.client_datacenter',
        'status': 'Upcoming',
      },
      {
        'dayKey': 'common.day.wednesday',
        'date': 'Feb 26, 2025',
        'titleKey': 'sample.shift.regular_day',
        'time': '08:30 AM - 05:30 PM',
        'locationKey': 'sample.location.hq_bldg_a',
        'status': 'Upcoming',
      },
      {
        'dayKey': 'common.day.thursday',
        'date': 'Feb 27, 2025',
        'titleKey': 'sample.shift.field_survey',
        'time': '08:00 AM - 04:30 PM',
        'locationKey': 'sample.location.western_hub',
        'status': 'Upcoming',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: Text('schedule.app_bar_title'.tr(context))),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MaxWidthContainer(
          maxWidth: 800,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'schedule.heading'.tr(context),
                style: AppTypography.headingLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'schedule.subtitle'.tr(context),
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: shifts.length,
                itemBuilder: (context, index) {
                  final shift = shifts[index];
                  final isActive = shift['status'] == 'Active';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppCard(
                      border: isActive
                          ? const BorderSide(color: AppColors.primary, width: 2)
                          : null,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.primary
                                  : AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  (shift['dayKey'] as String).tr(context),
                                  style: AppTypography.caption.copyWith(
                                    color: isActive
                                        ? Colors.white70
                                        : AppColors.textSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  shift['date'].toString().split(',')[0],
                                  style: AppTypography.headingSmall.copyWith(
                                    color: isActive
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (shift['titleKey'] as String).tr(context),
                                  style: AppTypography.headingSmall,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: AppColors.textMuted,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      shift['time'] as String,
                                      style: AppTypography.bodySmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 14,
                                      color: AppColors.textMuted,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      (shift['locationKey'] as String).tr(
                                        context,
                                      ),
                                      style: AppTypography.bodySmall,
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
