import 'package:flutter/material.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/app_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'titleKey': 'notification.mission_approved.title',
      'bodyKey': 'notification.mission_approved.body',
      'timeKey': 'time.10_mins_ago',
      'isRead': false,
      'icon': Icons.flight_takeoff,
      'color': AppColors.success,
    },
    {
      'id': '2',
      'titleKey': 'notification.leave_alert.title',
      'bodyKey': 'notification.leave_alert.body',
      'timeKey': 'time.2_hours_ago',
      'isRead': false,
      'icon': Icons.beach_access,
      'color': AppColors.info,
    },
    {
      'id': '3',
      'titleKey': 'notification.checkin_confirm.title',
      'bodyKey': 'notification.checkin_confirm.body',
      'timeKey': 'time.yesterday',
      'isRead': true,
      'icon': Icons.how_to_reg,
      'color': AppColors.primary,
    },
    {
      'id': '4',
      'titleKey': 'notification.sys_maint.title',
      'bodyKey': 'notification.sys_maint.body',
      'timeKey': 'time.2_days_ago',
      'isRead': true,
      'icon': Icons.build_circle_outlined,
      'color': AppColors.warning,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notifications.app_bar_title'.tr(context)),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var item in _notifications) {
                  item['isRead'] = true;
                }
              });
            },
            child: Text(
              'notifications.btn_mark_all_read'.tr(context),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MaxWidthContainer(
          maxWidth: 800,
          child: Column(
            children: _notifications.map((item) {
              final isRead = item['isRead'] as bool;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  backgroundColor: isRead
                      ? Colors.white
                      : AppColors.surfaceVariant.withOpacity(0.5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (item['color'] as Color).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: item['color'] as Color,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  (item['titleKey'] as String).tr(context),
                                  style: AppTypography.headingSmall.copyWith(
                                    fontWeight: isRead
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  (item['timeKey'] as String).tr(context),
                                  style: AppTypography.caption,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              (item['bodyKey'] as String).tr(context),
                              style: AppTypography.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
