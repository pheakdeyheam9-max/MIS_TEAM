import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import '../../../core/localization/localize_key.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/employee_entity.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../controllers/employee_controller.dart';

class EmployeeFormScreen extends StatefulWidget {
  final EmployeeEntity? employee;

  const EmployeeFormScreen({super.key, this.employee});

  @override
  State<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _employeeIdController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _roleController;
  late TextEditingController _departmentController;
  late TextEditingController _phoneController;
  String _selectedStatus = 'Active';

  bool get isEditing => widget.employee != null;

  @override
  void initState() {
    super.initState();
    final emp = widget.employee;
    _employeeIdController = TextEditingController(
      text:
          emp?.employeeId ??
          'EMP-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
    );
    _nameController = TextEditingController(text: emp?.name ?? '');
    _emailController = TextEditingController(text: emp?.email ?? '');
    _roleController = TextEditingController(text: emp?.role ?? '');
    _departmentController = TextEditingController(text: emp?.department ?? '');
    _phoneController = TextEditingController(text: emp?.phoneNumber ?? '');
    _selectedStatus = emp?.status ?? 'Active';
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    _departmentController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<EmployeeController>();
      final emp = widget.employee;

      final employeeData = EmployeeEntity(
        id: emp?.id ?? '',
        employeeId: _employeeIdController.text.trim(),
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        role: _roleController.text.trim(),
        department: _departmentController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        status: _selectedStatus,
        joinDate: emp?.joinDate ?? DateTime.now().toString().split(' ')[0],
        firstName: emp?.firstName,
        lastName: emp?.lastName,
        salary: emp?.salary,
        gender: emp?.gender,
        dateOfBirth: emp?.dateOfBirth,
        address: emp?.address,
        avatarUrl: emp?.avatarUrl,
      );

      final success = isEditing
          ? await controller.updateEmployee(employeeData)
          : await controller.createEmployee(employeeData);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditing
                    ? 'employees.update_success'.tr(context)
                    : 'employees.create_success'.tr(context),
              ),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                controller.errorMessage.value.isNotEmpty
                    ? controller.errorMessage.value
                    : 'employees.save_failed'.tr(context),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? 'employees.edit_title'.tr(context)
              : 'employees.add_title'.tr(context),
        ),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: MaxWidthContainer(
              maxWidth: 600,
              child: AppCard(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        isEditing
                            ? 'employees.edit_subtitle'.tr(context)
                            : 'employees.add_subtitle'.tr(context),
                        style: AppTypography.headingMedium,
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        label: 'employees.field.employee_id'.tr(context),
                        hint: 'EMP-9824',
                        controller: _employeeIdController,
                        prefixIcon: Icons.badge_outlined,
                        validator: (val) => Validators.validateRequired(
                          val,
                          'employees.field.employee_id'.tr(context),
                          context,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'employees.field.name'.tr(context),
                        hint: 'Sarah Connor',
                        controller: _nameController,
                        prefixIcon: Icons.person_outline,
                        validator: (val) => Validators.validateRequired(
                          val,
                          'employees.field.name'.tr(context),
                          context,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'employees.field.email'.tr(context),
                        hint: 'sarah.connor@misteams.com',
                        controller: _emailController,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) =>
                            Validators.validateEmail(val, context),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'employees.field.role'.tr(context),
                        hint: 'Senior Software Engineer',
                        controller: _roleController,
                        prefixIcon: Icons.work_outline,
                        validator: (val) => Validators.validateRequired(
                          val,
                          'employees.field.role'.tr(context),
                          context,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'employees.field.department'.tr(context),
                        hint: 'Engineering & Operations',
                        controller: _departmentController,
                        prefixIcon: Icons.business_outlined,
                        validator: (val) => Validators.validateRequired(
                          val,
                          'employees.field.department'.tr(context),
                          context,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'employees.field.phone'.tr(context),
                        hint: '+855 12 345 678',
                        controller: _phoneController,
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (val) => Validators.validateRequired(
                          val,
                          'employees.field.phone'.tr(context),
                          context,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'employees.field.status'.tr(context),
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedStatus,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppColors.divider,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.toggle_on_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                        items: ['Active', 'On Leave', 'Inactive']
                            .map(
                              (status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedStatus = val);
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      Obx(
                        () => AppButton(
                          text: isEditing
                              ? 'btn.save_changes'.tr(context)
                              : 'btn.submit'.tr(context),
                          isLoading: controller.isSubmitting.value,
                          onPressed: _handleSubmit,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
