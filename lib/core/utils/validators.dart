import 'package:flutter/material.dart';
import '../localization/localize_key.dart';

class Validators {
  Validators._();

  static String? validateRequired(
    String? value,
    String fieldName, [
    BuildContext? context,
  ]) {
    if (value == null || value.trim().isEmpty) {
      if (context != null) {
        return 'validation.required'.tr(context, {'fieldName': fieldName});
      }
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateEmail(String? value, [BuildContext? context]) {
    if (value == null || value.trim().isEmpty) {
      if (context != null) {
        return 'validation.email_required'.tr(context);
      }
      return 'Email address is required';
    }
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      if (context != null) {
        return 'validation.email_invalid'.tr(context);
      }
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value, [BuildContext? context]) {
    if (value == null || value.isEmpty) {
      if (context != null) {
        return 'validation.password_required'.tr(context);
      }
      return 'Password is required';
    }
    if (value.length < 6) {
      if (context != null) {
        return 'validation.password_too_short'.tr(context);
      }
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String password, [
    BuildContext? context,
  ]) {
    if (value == null || value.isEmpty) {
      if (context != null) {
        return 'validation.confirm_password_required'.tr(context);
      }
      return 'Please confirm your password';
    }
    if (value != password) {
      if (context != null) {
        return 'validation.passwords_do_not_match'.tr(context);
      }
      return 'Passwords do not match';
    }
    return null;
  }
}
