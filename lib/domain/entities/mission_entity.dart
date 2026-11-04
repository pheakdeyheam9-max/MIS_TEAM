enum MissionStatus { pending, approved, rejected, completed }

class MissionTypeEntity {
  final String id;
  final String title;
  final String description;
  final String iconName;

  const MissionTypeEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
  });
}

class MissionRequestEntity {
  final String id;
  final String typeId;
  final String typeTitle;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final MissionStatus status;
  final DateTime createdAt;
  final String? rejectionReason;

  const MissionRequestEntity({
    required this.id,
    required this.typeId,
    required this.typeTitle,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.status,
    required this.createdAt,
    this.rejectionReason,
  });
}
