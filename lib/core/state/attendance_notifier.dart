import 'package:flutter/foundation.dart';

enum AttendanceStateStatus { notCheckedIn, working, shiftCompleted }

class AttendanceRecordState {
  final AttendanceStateStatus status;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String location;

  const AttendanceRecordState({
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    this.location = 'Corporate Headquarters - Building A',
  });

  Duration get workingDuration {
    if (checkInTime == null) return Duration.zero;
    final end = checkOutTime ?? DateTime.now();
    return end.difference(checkInTime!);
  }

  String get formattedDuration {
    final d = workingDuration;
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  AttendanceRecordState copyWith({
    AttendanceStateStatus? status,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? location,
  }) {
    return AttendanceRecordState(
      status: status ?? this.status,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      location: location ?? this.location,
    );
  }
}

class AttendanceNotifier {
  AttendanceNotifier._();

  static final ValueNotifier<AttendanceRecordState> attendanceNotifier =
      ValueNotifier<AttendanceRecordState>(
        const AttendanceRecordState(status: AttendanceStateStatus.notCheckedIn),
      );

  static AttendanceRecordState get currentState => attendanceNotifier.value;

  static void performCheckIn({String? location}) {
    final now = DateTime.now();
    attendanceNotifier.value = AttendanceRecordState(
      status: AttendanceStateStatus.working,
      checkInTime: now,
      location: location ?? 'Corporate Headquarters - Building A',
    );
  }

  static void performCheckOut({String? location}) {
    final now = DateTime.now();
    final previous = attendanceNotifier.value;
    attendanceNotifier.value = AttendanceRecordState(
      status: AttendanceStateStatus.shiftCompleted,
      checkInTime:
          previous.checkInTime ?? now.subtract(const Duration(hours: 8)),
      checkOutTime: now,
      location: location ?? previous.location,
    );
  }
}
