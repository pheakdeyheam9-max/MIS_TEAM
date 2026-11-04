import 'package:flutter/material.dart';
import '../../core/localization/app_localization.dart';
import '../../core/localization/localize_key.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class LanguageSelectorDialog extends StatelessWidget {
  const LanguageSelectorDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LanguageSelectorDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = AppLocalization.localeNotifier.value;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.language, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(
                'language_dialog.title'.tr(context),
                style: AppTypography.headingMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'language_dialog.subtitle'.tr(context),
            style: AppTypography.bodySmall,
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOptionTile(
            context,
            flag: '🇺🇸',
            title: 'language_dialog.english'.tr(context),
            locale: const Locale('en', 'US'),
            isSelected: currentLocale.languageCode == 'en',
          ),
          const Divider(height: 1),
          _buildOptionTile(
            context,
            flag: '🇰🇭',
            title: 'language_dialog.khmer'.tr(context),
            locale: const Locale('km', 'KH'),
            isSelected: currentLocale.languageCode == 'km',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('language_dialog.cancel'.tr(context)),
        ),
      ],
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required String flag,
    required String title,
    required Locale locale,
    required bool isSelected,
  }) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(
        title,
        style: AppTypography.bodyLarge.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : const Icon(
              Icons.radio_button_unchecked,
              color: AppColors.textMuted,
            ),
      onTap: () {
        AppLocalization.changeLocale(locale);
        Navigator.pop(context);
      },
    );
  }
}
