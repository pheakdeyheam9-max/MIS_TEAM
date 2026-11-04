import '../../domain/entities/attendance_entity.dart';

class AttendanceModel extends AttendanceEntity {
  const AttendanceModel({
    required super.id,
    required super.date,
    super.checkInTime,
    super.checkOutTime,
    super.checkInLocation,
    super.checkOutLocation,
    required super.status,
    super.workingHours,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      checkInTime: json['checkInTime'] != null
          ? DateTime.parse(json['checkInTime'])
          : null,
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.parse(json['checkOutTime'])
          : null,
      checkInLocation: json['checkInLocation'],
      checkOutLocation: json['checkOutLocation'],
      status: json['status'] ?? 'Absent',
      workingHours: json['workingHours'],
    );
  }
}
