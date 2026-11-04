import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/bindings/initial_binding.dart';
import 'core/localization/app_localization.dart';
import 'core/storage/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocalization.init(SharedPreferencesLocalStorageService());
  InitialBinding().dependencies();
  runApp(const MisTeamsApp());
}
