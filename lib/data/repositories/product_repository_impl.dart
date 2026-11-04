import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient apiClient;

  ProductRepositoryImpl({required this.apiClient});

  @override
  Future<ApiResult<List<ProductEntity>>> getProducts({
    int page = 1,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{};
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }

    return await apiClient.get<List<ProductEntity>>(
      ApiConstants.products,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      jsonParser: (data) {
        if (data is List) {
          return data
              .map(
                (json) => ProductModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        } else if (data is Map &&
            data.containsKey('data') &&
            data['data'] is List) {
          final list = data['data'] as List;
          return list
              .map(
                (json) => ProductModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        }
        return <ProductEntity>[];
      },
    );
  }

  @override
  Future<ApiResult<ProductEntity>> getProductById(String id) async {
    return await apiClient.get<ProductEntity>(
      '${ApiConstants.products}/$id',
      jsonParser: (data) => ProductModel.fromJson(data as Map<String, dynamic>),
    );
  }
}
