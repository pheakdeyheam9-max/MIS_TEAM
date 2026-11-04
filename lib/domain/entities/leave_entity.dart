enum LeaveStatus { pending, approved, rejected, cancelled }

class LeaveTypeEntity {
  final String id;
  final String name;
  final String description;
  final int availableDays;
  final int totalDays;

  const LeaveTypeEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.availableDays,
    required this.totalDays,
  });
}

class LeaveRequestEntity {
  final String id;
  final String leaveTypeId;
  final String leaveTypeName;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final String reason;
  final LeaveStatus status;
  final DateTime createdAt;

  const LeaveRequestEntity({
    required this.id,
    required this.leaveTypeId,
    required this.leaveTypeName,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.reason,
    required this.status,
    required this.createdAt,
  });
}
