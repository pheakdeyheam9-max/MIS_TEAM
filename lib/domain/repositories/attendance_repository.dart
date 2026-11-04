import '../../core/network/api_client.dart';
import '../entities/attendance_entity.dart';

abstract class AttendanceRepository {
  Future<ApiResult<AttendanceEntity?>> getTodayAttendance();
  Future<ApiResult<List<AttendanceEntity>>> getAttendanceHistory();
  Future<ApiResult<AttendanceEntity>> checkIn(String location, String? notes);
  Future<ApiResult<AttendanceEntity>> checkOut(String location, String? notes);
}
