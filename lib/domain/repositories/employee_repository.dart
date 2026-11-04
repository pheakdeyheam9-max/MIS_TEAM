import '../../core/network/api_client.dart';
import '../entities/employee_entity.dart';

abstract class EmployeeRepository {
  Future<ApiResult<List<EmployeeEntity>>> getEmployees({
    int page = 1,
    String? search,
  });

  Future<ApiResult<EmployeeEntity>> getEmployeeById(String id);

  Future<ApiResult<EmployeeEntity>> createEmployee(EmployeeEntity employee);

  Future<ApiResult<EmployeeEntity>> updateEmployee(EmployeeEntity employee);

  Future<ApiResult<bool>> deleteEmployee(String id);
}
