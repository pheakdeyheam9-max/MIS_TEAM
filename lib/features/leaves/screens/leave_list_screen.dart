import 'package:flutter/material.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../navigation/app_routes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/status_badge.dart';

class LeaveListScreen extends StatefulWidget {
  const LeaveListScreen({super.key});

  @override
  State<LeaveListScreen> createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen> {
  String _selectedFilterKey = 'All';

  @override
  Widget build(BuildContext context) {
    final rawLeaves = [
      {
        'id': 'LVE-2025-089',
        'titleKey': 'sample.leave.annual_title',
        'datesKey': 'sample.leave.annual_subtitle',
        'reasonKey': 'sample.leave.annual_reason',
        'statusKey': 'Approved',
      },
      {
        'id': 'LVE-2025-092',
        'titleKey': 'sample.leave.sick_title',
        'datesKey': 'sample.date.feb_10_11',
        'reasonKey': 'sample.leave.sick_reason',
        'statusKey': 'Approved',
      },
      {
        'id': 'LVE-2025-099',
        'titleKey': 'sample.leave.casual_title',
        'datesKey': 'sample.date.feb_28',
        'reasonKey': 'sample.leave.casual_reason',
        'statusKey': 'Pending',
      },
    ];

    final filteredLeaves = _selectedFilterKey == 'All'
        ? rawLeaves
        : rawLeaves.where((l) => l['statusKey'] == _selectedFilterKey).toList();

    return Scaffold(
      appBar: AppBar(title: Text('leave_list.app_bar_title'.tr(context))),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MaxWidthContainer(
          maxWidth: 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterChips(context),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredLeaves.length,
                itemBuilder: (context, index) {
                  final leave = filteredLeaves[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                leave['id'] as String,
                                style: AppTypography.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              StatusBadge(status: leave['statusKey'] as String),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            (leave['titleKey'] as String).tr(context),
                            style: AppTypography.headingSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (leave['datesKey'] as String).tr(context),
                            style: AppTypography.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'leave_list.item.reason'.tr(context, {
                              'reason': (leave['reasonKey'] as String).tr(
                                context,
                              ),
                            }),
                            style: AppTypography.bodyMedium,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.newLeaveRequest);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final filters = [
      {'key': 'All', 'label': 'common.filter.all'.tr(context)},
      {'key': 'Approved', 'label': 'status.approved'.tr(context)},
      {'key': 'Pending', 'label': 'status.pending'.tr(context)},
      {'key': 'Rejected', 'label': 'status.rejected'.tr(context)},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilterKey == filter['key'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter['label']!),
              selected: isSelected,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedFilterKey = filter['key']!);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
