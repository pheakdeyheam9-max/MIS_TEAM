import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../domain/repositories/product_repository.dart';
import '../controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProductRepository>()) {
      Get.lazyPut<ProductRepository>(
        () => ProductRepositoryImpl(apiClient: Get.find<ApiClient>()),
      );
    }
    Get.lazyPut<ProductController>(
      () => ProductController(productRepository: Get.find<ProductRepository>()),
    );
  }
}
