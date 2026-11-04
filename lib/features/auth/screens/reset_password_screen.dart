import 'package:flutter/material.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isSubmitted = false;

  void _handleReset() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isSubmitted = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('reset_password.app_bar_title'.tr(context)),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: MaxWidthContainer(
              maxWidth: 440,
              child: AppCard(
                padding: const EdgeInsets.all(24),
                child: _isSubmitted ? _buildSuccessView() : _buildFormView(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.lock_reset, size: 48, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            'reset_password.heading'.tr(context),
            style: AppTypography.headingLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'reset_password.instructions'.tr(context),
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AppTextField(
            label: 'reset_password.field.email_label'.tr(context),
            hint: 'reset_password.field.email_hint'.tr(context),
            controller: _emailController,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (val) => Validators.validateEmail(val, context),
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'reset_password.btn_send_link'.tr(context),
            isLoading: _isLoading,
            onPressed: _handleReset,
          ),
          const SizedBox(height: 12),
          AppButton(
            text: 'reset_password.btn_back_to_login'.tr(context),
            variant: AppButtonVariant.outline,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.mark_email_read, size: 64, color: AppColors.success),
        const SizedBox(height: 16),
        Text(
          'reset_password.success.heading'.tr(context),
          style: AppTypography.headingLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'reset_password.success.message'.tr(context, {
            'email': _emailController.text,
          }),
          style: AppTypography.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        AppButton(
          text: 'reset_password.btn_return_to_login'.tr(context),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
