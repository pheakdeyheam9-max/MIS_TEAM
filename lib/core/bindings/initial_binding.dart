import 'package:get/get.dart';
import '../network/api_client.dart';
import '../storage/local_storage.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/employee_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/employee_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../../features/auth/controllers/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Permanent Local Storage
    final localStorage = Get.put<LocalStorageService>(
      SharedPreferencesLocalStorageService(),
      permanent: true,
    );

    // Permanent API Client (with JWT Interceptor support)
    final apiClient = Get.put<ApiClient>(
      HttpApiClient(storage: localStorage),
      permanent: true,
    );

    // Repositories
    final authRepo = Get.put<AuthRepository>(
      AuthRepositoryImpl(apiClient: apiClient, storage: localStorage),
      permanent: true,
    );

    Get.put<ProductRepository>(
      ProductRepositoryImpl(apiClient: apiClient),
      permanent: true,
    );

    Get.put<EmployeeRepository>(
      EmployeeRepositoryImpl(apiClient: apiClient),
      permanent: true,
    );

    // Auth Controller
    Get.put<AuthController>(
      AuthController(authRepository: authRepo),
      permanent: true,
    );
  }
}
