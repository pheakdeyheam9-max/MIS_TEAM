import '../../core/network/api_client.dart';
import '../../domain/entities/leave_entity.dart';
import '../../domain/repositories/leave_repository.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final ApiClient apiClient;

  final List<LeaveTypeEntity> _types = const [
    LeaveTypeEntity(
      id: 'lt-1',
      name: 'Annual Vacation',
      description: 'Paid annual leave allocation for regular personal rest.',
      availableDays: 14,
      totalDays: 20,
    ),
    LeaveTypeEntity(
      id: 'lt-2',
      name: 'Sick Leave',
      description: 'Paid medical leave for recovery or health appointments.',
      availableDays: 8,
      totalDays: 10,
    ),
    LeaveTypeEntity(
      id: 'lt-3',
      name: 'Casual / Emergency',
      description: 'Short notice leave for urgent personal matters.',
      availableDays: 3,
      totalDays: 5,
    ),
    LeaveTypeEntity(
      id: 'lt-4',
      name: 'Unpaid Leave',
      description: 'Extended personal leave subject to management approval.',
      availableDays: 30,
      totalDays: 30,
    ),
  ];

  final List<LeaveRequestEntity> _leaves = [
    LeaveRequestEntity(
      id: 'LVE-2025-089',
      leaveTypeId: 'lt-1',
      leaveTypeName: 'Annual Vacation',
      startDate: DateTime.now().add(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 20)),
      totalDays: 5,
      reason: 'Family summer holiday trip.',
      status: LeaveStatus.approved,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    LeaveRequestEntity(
      id: 'LVE-2025-092',
      leaveTypeId: 'lt-2',
      leaveTypeName: 'Sick Leave',
      startDate: DateTime.now().subtract(const Duration(days: 12)),
      endDate: DateTime.now().subtract(const Duration(days: 11)),
      totalDays: 2,
      reason: 'Dental surgery and post-op rest.',
      status: LeaveStatus.approved,
      createdAt: DateTime.now().subtract(const Duration(days: 13)),
    ),
    LeaveRequestEntity(
      id: 'LVE-2025-099',
      leaveTypeId: 'lt-3',
      leaveTypeName: 'Casual / Emergency',
      startDate: DateTime.now().add(const Duration(days: 3)),
      endDate: DateTime.now().add(const Duration(days: 3)),
      totalDays: 1,
      reason: 'Home utility maintenance appointment.',
      status: LeaveStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
  ];

  LeaveRepositoryImpl({required this.apiClient});

  @override
  Future<ApiResult<List<LeaveTypeEntity>>> getLeaveTypes() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ApiResult.success(_types);
  }

  @override
  Future<ApiResult<List<LeaveRequestEntity>>> getLeaves() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResult.success(List.from(_leaves));
  }

  @override
  Future<ApiResult<LeaveRequestEntity>> createLeaveRequest(
    LeaveRequestEntity request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _leaves.insert(0, request);
    return ApiResult.success(request);
  }
}
