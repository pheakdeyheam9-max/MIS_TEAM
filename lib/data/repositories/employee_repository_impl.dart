import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/employee_repository.dart';
import '../models/employee_model.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final ApiClient apiClient;

  EmployeeRepositoryImpl({required this.apiClient});

  @override
  Future<ApiResult<List<EmployeeEntity>>> getEmployees({
    int page = 1,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{};
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }

    return await apiClient.get<List<EmployeeEntity>>(
      ApiConstants.employees,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      jsonParser: (data) {
        if (data is List) {
          return data
              .map(
                (json) => EmployeeModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        } else if (data is Map &&
            data.containsKey('data') &&
            data['data'] is List) {
          final list = data['data'] as List;
          return list
              .map(
                (json) => EmployeeModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        }
        return <EmployeeEntity>[];
      },
    );
  }

  @override
  Future<ApiResult<EmployeeEntity>> getEmployeeById(String id) async {
    return await apiClient.get<EmployeeEntity>(
      '${ApiConstants.employees}/$id',
      jsonParser: (data) =>
          EmployeeModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<EmployeeEntity>> createEmployee(
    EmployeeEntity employee,
  ) async {
    final model = EmployeeModel.fromEntity(employee);
    return await apiClient.post<EmployeeEntity>(
      ApiConstants.employees,
      body: model.toJson(),
      jsonParser: (data) =>
          EmployeeModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<EmployeeEntity>> updateEmployee(
    EmployeeEntity employee,
  ) async {
    final model = EmployeeModel.fromEntity(employee);
    return await apiClient.put<EmployeeEntity>(
      '${ApiConstants.employees}/${employee.id}',
      body: model.toJson(),
      jsonParser: (data) =>
          EmployeeModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResult<bool>> deleteEmployee(String id) async {
    return await apiClient.delete<bool>(
      '${ApiConstants.employees}/$id',
      jsonParser: (_) => true,
    );
  }
}
