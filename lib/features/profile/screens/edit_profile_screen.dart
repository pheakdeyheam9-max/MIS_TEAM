import 'package:flutter/material.dart';
import '../../../core/localization/localize_key.dart';
import '../../../core/state/user_notifier.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _departmentController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = UserNotifier.currentUser;
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phoneNumber);
    _departmentController = TextEditingController(text: user.department);
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          final currentUser = UserNotifier.currentUser;
          final updatedUser = UserEntity(
            id: currentUser.id,
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            role: currentUser.role,
            department: _departmentController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            employeeId: currentUser.employeeId,
            avatarUrl: currentUser.avatarUrl,
          );
          UserNotifier.updateUser(updatedUser);

          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('edit_profile.snackbar_success'.tr(context)),
            ),
          );
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('edit_profile.app_bar_title'.tr(context))),
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
                    'edit_profile.heading'.tr(context),
                    style: AppTypography.headingLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'edit_profile.subtitle'.tr(context),
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    label: 'edit_profile.field.name_label'.tr(context),
                    controller: _nameController,
                    prefixIcon: Icons.person_outline,
                    validator: (val) => Validators.validateRequired(
                      val,
                      'edit_profile.field.name_label'.tr(context),
                      context,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'edit_profile.field.email_label'.tr(context),
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    validator: (val) => Validators.validateEmail(val, context),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'edit_profile.field.phone_label'.tr(context),
                    controller: _phoneController,
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (val) => Validators.validateRequired(
                      val,
                      'edit_profile.field.phone_label'.tr(context),
                      context,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'edit_profile.field.department_label'.tr(context),
                    controller: _departmentController,
                    prefixIcon: Icons.business_outlined,
                    validator: (val) => Validators.validateRequired(
                      val,
                      'edit_profile.field.department_label'.tr(context),
                      context,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'edit_profile.btn_save'.tr(context),
                    isLoading: _isLoading,
                    onPressed: _handleSave,
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
