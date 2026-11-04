import 'package:flutter/material.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../navigation/app_routes.dart';
import '../../../shared/widgets/app_card.dart';

class LeaveTypesScreen extends StatelessWidget {
  const LeaveTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaveTypes = [
      {
        'id': 'lt-1',
        'title': 'leave_type.annual.title'.tr(context),
        'available': 14,
        'total': 20,
        'description': 'leave_type.annual.desc'.tr(context),
        'icon': Icons.beach_access,
      },
      {
        'id': 'lt-2',
        'title': 'leave_type.sick.title'.tr(context),
        'available': 8,
        'total': 10,
        'description': 'leave_type.sick.desc'.tr(context),
        'icon': Icons.local_hospital_outlined,
      },
      {
        'id': 'lt-3',
        'title': 'leave_type.casual.title'.tr(context),
        'available': 3,
        'total': 5,
        'description': 'leave_type.casual.desc'.tr(context),
        'icon': Icons.warning_amber_outlined,
      },
      {
        'id': 'lt-4',
        'title': 'leave_type.unpaid.title'.tr(context),
        'available': 30,
        'total': 30,
        'description': 'leave_type.unpaid.desc'.tr(context),
        'icon': Icons.request_quote_outlined,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: Text('leave_types.app_bar_title'.tr(context))),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MaxWidthContainer(
          maxWidth: 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'leave_types.heading'.tr(context),
                style: AppTypography.headingLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'leave_types.subtitle'.tr(context),
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: leaveTypes.length,
                itemBuilder: (context, index) {
                  final item = leaveTypes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppCard(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.leaveList);
                      },
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
                                child: Icon(
                                  item['icon'] as IconData,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      style: AppTypography.headingSmall,
                                    ),
                                    Text(
                                      item['description'] as String,
                                      style: AppTypography.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'leave_types.days_badge'.tr(context, {
                                    'available': item['available'],
                                    'total': item['total'],
                                  }),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
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
          Navigator.pushNamed(context, AppRoutes.newLeaveRequest);
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text('leave_types.fab_new_leave'.tr(context)),
      ),
    );
  }
}
