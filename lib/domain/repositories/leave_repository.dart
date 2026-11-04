import '../../core/network/api_client.dart';
import '../entities/leave_entity.dart';

abstract class LeaveRepository {
  Future<ApiResult<List<LeaveTypeEntity>>> getLeaveTypes();
  Future<ApiResult<List<LeaveRequestEntity>>> getLeaves();
  Future<ApiResult<LeaveRequestEntity>> createLeaveRequest(
    LeaveRequestEntity request,
  );
}
