import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import '../../../core/localization/localize_key.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/validators.dart';
import '../../../navigation/app_routes.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'admin');
  final _passwordController = TextEditingController(text: 'Admin@1234');

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authController = Get.find<AuthController>();
      final success = await authController.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        if (success) {
          Navigator.pushReplacementNamed(context, AppRoutes.mainShell);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                authController.errorMessage.value.isNotEmpty
                    ? authController.errorMessage.value
                    : 'auth.error.invalid_credentials'.tr(context),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: MaxWidthContainer(
              maxWidth: 440,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/app_logo.png',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'login.subtitle'.tr(context),
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  AppCard(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'login.welcome_back'.tr(context),
                            style: AppTypography.headingMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'login.enter_credentials'.tr(context),
                            style: AppTypography.bodySmall,
                          ),
                          const SizedBox(height: 24),
                          AppTextField(
                            label: 'login.field.username_label'.tr(context),
                            hint: 'login.field.username_hint'.tr(context),
                            controller: _usernameController,
                            prefixIcon: Icons.person_outline,
                            keyboardType: TextInputType.text,
                            validator: (val) => Validators.validateRequired(
                              val,
                              'login.field.username_label'.tr(context),
                              context,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            label: 'login.field.password_label'.tr(context),
                            hint: '••••••••',
                            controller: _passwordController,
                            isPassword: true,
                            prefixIcon: Icons.lock_outline,
                            validator: (val) =>
                                Validators.validatePassword(val, context),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: AppButton(
                              text: 'login.btn_forgot_password'.tr(context),
                              variant: AppButtonVariant.text,
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.resetPassword,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => AppButton(
                              text: 'login.btn_sign_in'.tr(context),
                              isLoading: authController.isLoading.value,
                              onPressed: _handleLogin,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'login.footer_caption'.tr(context),
                    style: AppTypography.caption,
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
