import 'package:get/get.dart';
import '../../../domain/entities/employee_entity.dart';
import '../../../domain/repositories/employee_repository.dart';

class EmployeeController extends GetxController {
  final EmployeeRepository employeeRepository;

  EmployeeController({required this.employeeRepository});

  final RxList<EmployeeEntity> employees = <EmployeeEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
    debounce(
      searchQuery,
      (_) => fetchEmployees(),
      time: const Duration(milliseconds: 300),
    );
  }

  Future<void> fetchEmployees({bool isRefresh = false}) async {
    if (isRefresh) {
      isRefreshing.value = true;
    } else {
      isLoading.value = true;
    }
    errorMessage.value = '';

    final result = await employeeRepository.getEmployees(
      search: searchQuery.value.trim().isEmpty
          ? null
          : searchQuery.value.trim(),
    );

    if (isRefresh) {
      isRefreshing.value = false;
    } else {
      isLoading.value = false;
    }

    if (result.isSuccess && result.data != null) {
      employees.assignAll(result.data!);
    } else {
      errorMessage.value =
          result.errorMessage ?? 'Failed to load employee directory.';
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  Future<bool> createEmployee(EmployeeEntity employee) async {
    isSubmitting.value = true;
    errorMessage.value = '';

    final result = await employeeRepository.createEmployee(employee);
    isSubmitting.value = false;

    if (result.isSuccess && result.data != null) {
      await fetchEmployees(isRefresh: true);
      return true;
    } else {
      errorMessage.value =
          result.errorMessage ?? 'Failed to create new employee.';
      return false;
    }
  }

  Future<bool> updateEmployee(EmployeeEntity employee) async {
    isSubmitting.value = true;
    errorMessage.value = '';

    final result = await employeeRepository.updateEmployee(employee);
    isSubmitting.value = false;

    if (result.isSuccess) {
      final index = employees.indexWhere((e) => e.id == employee.id);
      if (index != -1) {
        employees[index] = employee;
      } else {
        await fetchEmployees(isRefresh: true);
      }
      return true;
    } else {
      errorMessage.value =
          result.errorMessage ?? 'Failed to update employee information.';
      return false;
    }
  }

  Future<bool> deleteEmployee(String id) async {
    isSubmitting.value = true;
    errorMessage.value = '';

    final result = await employeeRepository.deleteEmployee(id);
    isSubmitting.value = false;

    if (result.isSuccess) {
      employees.removeWhere((e) => e.id == id || e.employeeId == id);
      return true;
    } else {
      errorMessage.value = result.errorMessage ?? 'Failed to delete employee.';
      return false;
    }
  }
}
