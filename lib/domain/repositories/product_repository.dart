import '../../core/network/api_client.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<ApiResult<List<ProductEntity>>> getProducts({
    int page = 1,
    String? search,
  });

  Future<ApiResult<ProductEntity>> getProductById(String id);
}
