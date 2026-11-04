import 'package:flutter/material.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../navigation/app_routes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/status_badge.dart';

class MissionListScreen extends StatefulWidget {
  const MissionListScreen({super.key});

  @override
  State<MissionListScreen> createState() => _MissionListScreenState();
}

class _MissionListScreenState extends State<MissionListScreen> {
  String _selectedFilterKey = 'All';

  @override
  Widget build(BuildContext context) {
    final rawMissions = [
      {
        'id': 'MIS-2025-001',
        'titleKey': 'sample.mission.datacenter_title',
        'typeKey': 'mission_type.client_site_inspection.title',
        'locationKey': 'sample.location.north_wing',
        'datesKey': 'sample.date.feb_24_28',
        'statusKey': 'Approved',
      },
      {
        'id': 'MIS-2025-002',
        'titleKey': 'sample.mission.fiber_title',
        'typeKey': 'mission_type.field_audit.title',
        'locationKey': 'sample.location.western_sector_c',
        'datesKey': 'sample.date.mar_05_09',
        'statusKey': 'Pending',
      },
      {
        'id': 'MIS-2025-003',
        'titleKey': 'sample.mission.server_grid_title',
        'typeKey': 'mission_type.technical_support.title',
        'locationKey': 'sample.location.central_command',
        'datesKey': 'sample.date.jan_10_12',
        'statusKey': 'Completed',
      },
      {
        'id': 'MIS-2025-004',
        'titleKey': 'sample.mission.partner_training_title',
        'typeKey': 'mission_type.partner_training.title',
        'locationKey': 'sample.location.metro_tech',
        'datesKey': 'sample.date.dec_15_18',
        'statusKey': 'Rejected',
      },
    ];

    final filteredMissions = _selectedFilterKey == 'All'
        ? rawMissions
        : rawMissions
              .where((m) => m['statusKey'] == _selectedFilterKey)
              .toList();

    return Scaffold(
      appBar: AppBar(title: Text('mission_list.app_bar_title'.tr(context))),
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
                itemCount: filteredMissions.length,
                itemBuilder: (context, index) {
                  final mission = filteredMissions[index];
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
                                mission['id'] as String,
                                style: AppTypography.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              StatusBadge(
                                status: mission['statusKey'] as String,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            (mission['titleKey'] as String).tr(context),
                            style: AppTypography.headingSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'mission_list.item.category'.tr(context, {
                              'type': (mission['typeKey'] as String).tr(
                                context,
                              ),
                            }),
                            style: AppTypography.bodySmall,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  (mission['locationKey'] as String).tr(
                                    context,
                                  ),
                                  style: AppTypography.bodySmall,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                (mission['datesKey'] as String).tr(context),
                                style: AppTypography.bodySmall,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.newMissionRequest);
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
      {'key': 'Completed', 'label': 'status.completed'.tr(context)},
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
