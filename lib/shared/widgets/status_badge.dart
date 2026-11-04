import 'package:flutter/material.dart';
import '../../core/localization/localize_key.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final Color? customColor;
  final Color? customBackground;

  const StatusBadge({
    super.key,
    String? status,
    String? text,
    Color? customColor,
    Color? color,
    this.customBackground,
  }) : status = status ?? text ?? '',
       customColor = customColor ?? color;

  String _getLocalizedStatus(BuildContext context) {
    final normalized = status.toLowerCase();
    if (normalized == 'approved') return 'status.approved'.tr(context);
    if (normalized == 'completed') return 'status.completed'.tr(context);
    if (normalized == 'present') return 'status.present'.tr(context);
    if (normalized == 'pending') return 'status.pending'.tr(context);
    if (normalized == 'in progress') return 'status.in_progress'.tr(context);
    if (normalized == 'rejected') return 'status.rejected'.tr(context);
    if (normalized == 'cancelled') return 'status.cancelled'.tr(context);
    if (normalized == 'absent') return 'status.absent'.tr(context);
    if (normalized == 'late') return 'status.late'.tr(context);
    if (normalized == 'upcoming') return 'status.upcoming'.tr(context);
    if (normalized == 'active') return 'status.active'.tr(context);
    if (normalized == 'checked out') return 'status.checked_out'.tr(context);
    if (normalized == 'checked in') return 'status.checked_in'.tr(context);
    if (normalized == 'on duty') return 'status.on_duty'.tr(context);
    return status;
  }

  @override
  Widget build(BuildContext context) {
    Color bg = AppColors.surfaceVariant;
    Color fg = AppColors.textSecondary;

    final normalized = status.toLowerCase();

    if (normalized.contains('approved') ||
        normalized.contains('completed') ||
        normalized.contains('present')) {
      bg = AppColors.successBackground;
      fg = AppColors.success;
    } else if (normalized.contains('pending') ||
        normalized.contains('in progress')) {
      bg = AppColors.warningBackground;
      fg = AppColors.warning;
    } else if (normalized.contains('rejected') ||
        normalized.contains('cancelled') ||
        normalized.contains('absent')) {
      bg = AppColors.errorBackground;
      fg = AppColors.error;
    } else if (normalized.contains('late') || normalized.contains('upcoming')) {
      bg = AppColors.infoBackground;
      fg = AppColors.info;
    }

    if (customColor != null) fg = customColor!;
    if (customBackground != null) bg = customBackground!;

    final displayText = _getLocalizedStatus(context).toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayText,
        style: AppTypography.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
