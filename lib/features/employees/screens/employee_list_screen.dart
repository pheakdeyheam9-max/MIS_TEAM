import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import '../../../core/localization/localize_key.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/employee_entity.dart';
import '../../../navigation/app_routes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/status_badge.dart';
import '../controllers/employee_controller.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmDelete(BuildContext context, EmployeeEntity employee) {
    final controller = Get.find<EmployeeController>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.error),
            const SizedBox(width: 8),
            Text('employees.delete_title'.tr(context)),
          ],
        ),
        content: Text(
          'employees.delete_confirm_msg'.tr(context, {'name': employee.name}),
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('btn.cancel'.tr(context)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final successMsg = 'employees.delete_success'.tr(context);
              Navigator.pop(ctx);
              final success = await controller.deleteEmployee(employee.id);
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(
                    success ? successMsg : controller.errorMessage.value,
                  ),
                  backgroundColor: success
                      ? AppColors.success
                      : AppColors.error,
                ),
              );
            },
            child: Text('btn.delete'.tr(context)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('employees.title'.tr(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => controller.fetchEmployees(isRefresh: true),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.employeeForm);
        },
        icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
        label: Text(
          'employees.btn_add_employee'.tr(context),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: MaxWidthContainer(
                maxWidth: 800,
                child: AppTextField(
                  hint: 'employees.search_hint'.tr(context),
                  controller: _searchController,
                  prefixIcon: Icons.search,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            controller.onSearchChanged('');
                            setState(() {});
                          },
                        )
                      : null,
                  onChanged: (val) {
                    controller.onSearchChanged(val);
                    setState(() {});
                  },
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    !controller.isRefreshing.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty &&
                    controller.employees.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            controller.errorMessage.value,
                            style: AppTypography.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => controller.fetchEmployees(),
                            icon: const Icon(Icons.refresh),
                            label: Text('btn.retry'.tr(context)),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (controller.employees.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => controller.fetchEmployees(isRefresh: true),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: 400,
                        child: Center(
                          child: EmptyStateWidget(
                            icon: Icons.people_outline,
                            title: 'employees.empty_title'.tr(context),
                            subtitle: 'employees.empty_message'.tr(context),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchEmployees(isRefresh: true),
                  color: AppColors.primary,
                  child: Center(
                    child: MaxWidthContainer(
                      maxWidth: 800,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                        itemCount: controller.employees.length,
                        separatorBuilder: (_, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final employee = controller.employees[index];
                          return _buildEmployeeCard(context, employee);
                        },
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, EmployeeEntity employee) {
    final statusColor = employee.status == 'Active'
        ? AppColors.success
        : (employee.status == 'On Leave'
              ? AppColors.warning
              : AppColors.textMuted);

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primary,
                child: Text(
                  employee.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            employee.name,
                            style: AppTypography.headingMedium.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        StatusBadge(
                          status: employee.status,
                          customColor: statusColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      employee.role,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(employee.department, style: AppTypography.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.badge_outlined,
                size: 16,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                employee.employeeId,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.email_outlined,
                size: 16,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  employee.email,
                  style: AppTypography.caption,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 16,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(employee.phoneNumber, style: AppTypography.caption),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                tooltip: 'Edit Employee',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.employeeForm,
                    arguments: employee,
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                  size: 20,
                ),
                tooltip: 'Delete Employee',
                onPressed: () => _confirmDelete(context, employee),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
