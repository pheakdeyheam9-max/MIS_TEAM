import 'package:flutter/material.dart';
import 'app_localization.dart';

extension LocalizeKey on String {
  String tr(BuildContext context, [Map<String, dynamic>? args]) {
    return AppLocalization.of(context)?.translate(this, args) ?? this;
  }
}
