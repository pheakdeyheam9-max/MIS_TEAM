import 'package:flutter/material.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void _handleChangePassword() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('change_password.snackbar_success'.tr(context)),
            ),
          );
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('change_password.app_bar_title'.tr(context))),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MaxWidthContainer(
          maxWidth: 800,
          child: AppCard(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'change_password.heading'.tr(context),
                    style: AppTypography.headingLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'change_password.subtitle'.tr(context),
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    label: 'change_password.field.current_password_label'.tr(
                      context,
                    ),
                    hint: '••••••••',
                    controller: _currentPasswordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
                    validator: (val) =>
                        Validators.validatePassword(val, context),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'change_password.field.new_password_label'.tr(
                      context,
                    ),
                    hint: '••••••••',
                    controller: _newPasswordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_reset,
                    validator: (val) =>
                        Validators.validatePassword(val, context),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'change_password.field.confirm_password_label'.tr(
                      context,
                    ),
                    hint: '••••••••',
                    controller: _confirmPasswordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_reset,
                    validator: (val) => Validators.validateConfirmPassword(
                      val,
                      _newPasswordController.text,
                      context,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'change_password.btn_update'.tr(context),
                    isLoading: _isLoading,
                    onPressed: _handleChangePassword,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
