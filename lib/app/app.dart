import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/constants/app_constants.dart';
import '../core/localization/app_localization.dart';
import '../core/theme/app_theme.dart';
import '../navigation/app_router.dart';
import '../navigation/app_routes.dart';
import '../navigation/navigation_service.dart';

class MisTeamsApp extends StatelessWidget {
  const MisTeamsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: AppLocalization.localeNotifier,
      builder: (context, currentLocale, child) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          locale: currentLocale,
          supportedLocales: AppLocalization.supportedLocales,
          localizationsDelegates: const [
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          navigatorKey: NavigationService.navigatorKey,
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: AppRoutes.splash,
        );
      },
    );
  }
}
