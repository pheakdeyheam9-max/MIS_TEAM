import '../../domain/entities/leave_entity.dart';

class LeaveTypeModel extends LeaveTypeEntity {
  const LeaveTypeModel({
    required super.id,
    required super.name,
    required super.description,
    required super.availableDays,
    required super.totalDays,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      availableDays: json['availableDays'] ?? 0,
      totalDays: json['totalDays'] ?? 0,
    );
  }
}

class LeaveRequestModel extends LeaveRequestEntity {
  const LeaveRequestModel({
    required super.id,
    required super.leaveTypeId,
    required super.leaveTypeName,
    required super.startDate,
    required super.endDate,
    required super.totalDays,
    required super.reason,
    required super.status,
    required super.createdAt,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestModel(
      id: json['id'] ?? '',
      leaveTypeId: json['leaveTypeId'] ?? '',
      leaveTypeName: json['leaveTypeName'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      totalDays: json['totalDays'] ?? 1,
      reason: json['reason'] ?? '',
      status: LeaveStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => LeaveStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
