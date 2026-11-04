import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../storage/local_storage.dart';

class AppLocalization {
  final Locale locale;
  Map<String, String> _localizedStrings = {};

  AppLocalization(this.locale);

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  static const LocalizationsDelegate<AppLocalization> delegate =
      _AppLocalizationDelegate();

  static final ValueNotifier<Locale> localeNotifier = ValueNotifier(
    const Locale('en', 'US'),
  );
  static LocalStorageService? _storage;

  static const String _storageKeyLocaleLanguage = 'app_language_code';
  static const String _storageKeyLocaleCountry = 'app_country_code';

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('km', 'KH'),
  ];

  static Future<void> init(LocalStorageService storage) async {
    _storage = storage;
    final savedLang = await storage.getString(_storageKeyLocaleLanguage);
    final savedCountry = await storage.getString(_storageKeyLocaleCountry);

    if (savedLang != null && savedLang.isNotEmpty) {
      localeNotifier.value = Locale(savedLang, savedCountry ?? '');
    }
  }

  static Future<void> changeLocale(Locale newLocale) async {
    if (!supportedLocales.contains(newLocale)) return;
    localeNotifier.value = newLocale;
    if (_storage != null) {
      await _storage!.saveString(
        _storageKeyLocaleLanguage,
        newLocale.languageCode,
      );
      await _storage!.saveString(
        _storageKeyLocaleCountry,
        newLocale.countryCode ?? '',
      );
    }
  }

  Future<bool> load() async {
    final langCode = locale.languageCode;
    final countryCode = locale.countryCode ?? '';
    final assetPath =
        'assets/translations/$langCode${countryCode.isNotEmpty ? '-$countryCode' : ''}.json';

    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
      return true;
    } catch (e) {
      debugPrint('Error loading localization asset $assetPath: $e');
      _localizedStrings = {'app.name': 'MIS TEAMS'};
      return false;
    }
  }

  String translate(String key, [Map<String, dynamic>? args]) {
    String translation = _localizedStrings[key] ?? key;
    if (args != null && args.isNotEmpty) {
      args.forEach((argKey, argValue) {
        translation = translation.replaceAll('{$argKey}', argValue.toString());
      });
    }
    return translation;
  }
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'km'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    final localization = AppLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(_AppLocalizationDelegate old) => false;
}
