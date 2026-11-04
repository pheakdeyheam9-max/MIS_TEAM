import 'package:get/get.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/repositories/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository productRepository;

  ProductController({required this.productRepository});

  final RxList<ProductEntity> products = <ProductEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    debounce(
      searchQuery,
      (_) => fetchProducts(),
      time: const Duration(milliseconds: 300),
    );
  }

  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      isRefreshing.value = true;
    } else {
      isLoading.value = true;
    }
    errorMessage.value = '';

    final result = await productRepository.getProducts(
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
      products.assignAll(result.data!);
    } else {
      errorMessage.value =
          result.errorMessage ?? 'Failed to load product catalog.';
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }
}
