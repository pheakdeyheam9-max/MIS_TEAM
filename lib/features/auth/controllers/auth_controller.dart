import 'package:get/get.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  final RxBool isAuthenticated = false.obs;
  final Rxn<UserEntity> currentUser = Rxn<UserEntity>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<bool> checkAuthStatus() async {
    final result = await authRepository.getCurrentUser();
    if (result.isSuccess && result.data != null) {
      currentUser.value = result.data;
      isAuthenticated.value = true;
      return true;
    } else {
      currentUser.value = null;
      isAuthenticated.value = false;
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await authRepository.login(email, password);
    isLoading.value = false;

    if (result.isSuccess && result.data != null) {
      currentUser.value = result.data;
      isAuthenticated.value = true;
      return true;
    } else {
      errorMessage.value =
          result.errorMessage ?? 'Login failed. Please try again.';
      return false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    await authRepository.logout();
    currentUser.value = null;
    isAuthenticated.value = false;
    isLoading.value = false;
  }
}
