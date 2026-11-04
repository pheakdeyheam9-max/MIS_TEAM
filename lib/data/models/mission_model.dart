import '../../domain/entities/mission_entity.dart';

class MissionTypeModel extends MissionTypeEntity {
  const MissionTypeModel({
    required super.id,
    required super.title,
    required super.description,
    required super.iconName,
  });

  factory MissionTypeModel.fromJson(Map<String, dynamic> json) {
    return MissionTypeModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      iconName: json['iconName'] ?? '',
    );
  }
}

class MissionRequestModel extends MissionRequestEntity {
  const MissionRequestModel({
    required super.id,
    required super.typeId,
    required super.typeTitle,
    required super.title,
    required super.description,
    required super.startDate,
    required super.endDate,
    required super.location,
    required super.status,
    required super.createdAt,
    super.rejectionReason,
  });

  factory MissionRequestModel.fromJson(Map<String, dynamic> json) {
    return MissionRequestModel(
      id: json['id'] ?? '',
      typeId: json['typeId'] ?? '',
      typeTitle: json['typeTitle'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      location: json['location'] ?? '',
      status: MissionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MissionStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      rejectionReason: json['rejectionReason'],
    );
  }
}
