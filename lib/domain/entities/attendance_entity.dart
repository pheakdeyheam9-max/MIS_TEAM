class AttendanceEntity {
  final String id;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? checkInLocation;
  final String? checkOutLocation;
  final String status; // Present, Late, Absent, On Leave
  final String? workingHours;

  const AttendanceEntity({
    required this.id,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.checkInLocation,
    this.checkOutLocation,
    required this.status,
    this.workingHours,
  });
}
