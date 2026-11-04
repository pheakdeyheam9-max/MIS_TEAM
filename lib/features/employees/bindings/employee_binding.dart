import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../data/repositories/employee_repository_impl.dart';
import '../../../domain/repositories/employee_repository.dart';
import '../controllers/employee_controller.dart';

class EmployeeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<EmployeeRepository>()) {
      Get.lazyPut<EmployeeRepository>(
        () => EmployeeRepositoryImpl(apiClient: Get.find<ApiClient>()),
      );
    }
    Get.lazyPut<EmployeeController>(
      () => EmployeeController(
        employeeRepository: Get.find<EmployeeRepository>(),
      ),
    );
  }
}
