import 'package:flutter/material.dart';
import '../../core/localization/localize_key.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/entities/calendar_event.dart';
import 'add_edit_event_dialog.dart';

enum EventDetailsActionResult { edited, deleted, none }

class EventDetailsDialog extends StatelessWidget {
  final CalendarEvent event;
  final Function(CalendarEvent updatedEvent) onUpdate;
  final Function(String eventId) onDelete;

  const EventDetailsDialog({
    super.key,
    required this.event,
    required this.onUpdate,
    required this.onDelete,
  });

  static Future<EventDetailsActionResult?> show(
    BuildContext context, {
    required CalendarEvent event,
    required Function(CalendarEvent updatedEvent) onUpdate,
    required Function(String eventId) onDelete,
  }) {
    return showDialog<EventDetailsActionResult>(
      context: context,
      builder: (context) => EventDetailsDialog(
        event: event,
        onUpdate: onUpdate,
        onDelete: onDelete,
      ),
    );
  }

  String _getCategoryTranslationKey(String cat) {
    final lower = cat.toLowerCase();
    if (lower == 'meeting') return 'calendar.category.meeting';
    if (lower == 'mission') return 'calendar.category.mission';
    if (lower == 'internal') return 'calendar.category.internal';
    if (lower == 'holiday') return 'calendar.category.holiday';
    if (lower == 'personal') return 'calendar.category.personal';
    if (lower == 'technical') return 'calendar.category.technical';
    return cat;
  }

  void _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('calendar.confirm_delete_title'.tr(ctx)),
        content: Text('calendar.confirm_delete_msg'.tr(ctx)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('calendar.btn.cancel'.tr(ctx)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('calendar.btn.delete'.tr(ctx)),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      onDelete(event.id);
      Navigator.pop(context, EventDetailsActionResult.deleted);
    }
  }

  void _handleEdit(BuildContext context) async {
    final updated = await AddEditEventDialog.show(context, eventToEdit: event);
    if (updated != null && context.mounted) {
      onUpdate(updated);
      Navigator.pop(context, EventDetailsActionResult.edited);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryKey = _getCategoryTranslationKey(event.category);
    final categoryLabel = categoryKey.contains('.')
        ? categoryKey.tr(context)
        : categoryKey;

    final startDateStr =
        '${event.startDate.day}/${event.startDate.month}/${event.startDate.year}';
    final endDateStr =
        '${event.endDate.day}/${event.endDate.month}/${event.endDate.year}';
    final timeStr =
        '${event.startTime.format(context)} - ${event.endTime.format(context)}';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: event.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: event.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    categoryLabel,
                    style: TextStyle(
                      color: event.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.primary,
                  ),
                  onPressed: () => _handleEdit(context),
                  tooltip: 'calendar.edit_event'.tr(context),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                  onPressed: () => _confirmDelete(context),
                  tooltip: 'calendar.delete_event'.tr(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(event.title, style: AppTypography.headingLarge),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '$startDateStr ($timeStr)',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (startDateStr != endDateStr) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.event, size: 20, color: AppColors.textMuted),
                  const SizedBox(width: 12),
                  Text('Until $endDateStr', style: AppTypography.bodySmall),
                ],
              ),
            ],
            if (event.location.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      event.location,
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
            if (event.description.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'calendar.field.description'.tr(context),
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(event.description, style: AppTypography.bodyMedium),
            ],
            if (event.reminder != 'None') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.notifications_active_outlined,
                    size: 18,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${'calendar.field.reminder'.tr(context)}: ${event.reminder}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () =>
                    Navigator.pop(context, EventDetailsActionResult.none),
                child: Text('calendar.btn.close'.tr(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
