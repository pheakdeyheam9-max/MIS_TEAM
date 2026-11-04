import '../../core/network/api_client.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final ApiClient apiClient;

  AttendanceEntity? _todayAttendance;

  final List<AttendanceEntity> _history = [
    AttendanceEntity(
      id: 'ATT-101',
      date: DateTime.now().subtract(const Duration(days: 1)),
      checkInTime: DateTime.now().subtract(const Duration(days: 1, hours: 9)),
      checkOutTime: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      checkInLocation: 'HQ Office (34.05, -118.25)',
      checkOutLocation: 'HQ Office (34.05, -118.25)',
      status: 'Present',
      workingHours: '8h 00m',
    ),
    AttendanceEntity(
      id: 'ATT-102',
      date: DateTime.now().subtract(const Duration(days: 2)),
      checkInTime: DateTime.now().subtract(
        const Duration(days: 2, hours: 8, minutes: 45),
      ),
      checkOutTime: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
      checkInLocation: 'HQ Office (34.05, -118.25)',
      checkOutLocation: 'HQ Office (34.05, -118.25)',
      status: 'Present',
      workingHours: '7h 45m',
    ),
    AttendanceEntity(
      id: 'ATT-103',
      date: DateTime.now().subtract(const Duration(days: 3)),
      checkInTime: DateTime.now().subtract(
        const Duration(days: 3, hours: 9, minutes: 15),
      ),
      checkOutTime: DateTime.now().subtract(const Duration(days: 3, hours: 1)),
      checkInLocation: 'Regional Hub East',
      checkOutLocation: 'Regional Hub East',
      status: 'Late',
      workingHours: '7h 45m',
    ),
  ];

  AttendanceRepositoryImpl({required this.apiClient});

  @override
  Future<ApiResult<AttendanceEntity?>> getTodayAttendance() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ApiResult.success(_todayAttendance);
  }

  @override
  Future<ApiResult<List<AttendanceEntity>>> getAttendanceHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final list = <AttendanceEntity>[];
    if (_todayAttendance != null) {
      list.add(_todayAttendance!);
    }
    list.addAll(_history);
    return ApiResult.success(list);
  }

  @override
  Future<ApiResult<AttendanceEntity>> checkIn(
    String location,
    String? notes,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _todayAttendance = AttendanceEntity(
      id: 'ATT-${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      checkInTime: DateTime.now(),
      checkInLocation: location,
      status: 'Present',
    );
    return ApiResult.success(_todayAttendance!);
  }

  @override
  Future<ApiResult<AttendanceEntity>> checkOut(
    String location,
    String? notes,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_todayAttendance == null) {
      return ApiResult.error('No check-in record found for today.');
    }
    final now = DateTime.now();
    final duration = now.difference(_todayAttendance!.checkInTime!);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    _todayAttendance = AttendanceEntity(
      id: _todayAttendance!.id,
      date: _todayAttendance!.date,
      checkInTime: _todayAttendance!.checkInTime,
      checkOutTime: now,
      checkInLocation: _todayAttendance!.checkInLocation,
      checkOutLocation: location,
      status: 'Present',
      workingHours: '${hours}h ${minutes}m',
    );
    return ApiResult.success(_todayAttendance!);
  }
}
