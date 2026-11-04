import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.department,
    super.avatarUrl,
    required super.phoneNumber,
    required super.employeeId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String parsedRole = 'User';
    if (json['roles'] is List && (json['roles'] as List).isNotEmpty) {
      parsedRole = (json['roles'] as List).first.toString().replaceAll(
        'ROLE_',
        '',
      );
    } else if (json['role'] != null) {
      parsedRole = json['role'].toString();
    }

    final idStr = json['id']?.toString() ?? '';
    final usernameStr = json['username']?.toString() ?? '';
    final nameStr = json['name']?.toString() ?? usernameStr;

    return UserModel(
      id: idStr,
      name: nameStr.isNotEmpty ? nameStr : 'User',
      email: json['email']?.toString() ?? '',
      role: parsedRole,
      department: json['department']?.toString() ?? 'Operations',
      avatarUrl: json['avatarUrl']?.toString() ?? json['photoUrl']?.toString(),
      phoneNumber:
          json['phoneNumber']?.toString() ?? json['phone']?.toString() ?? '',
      employeeId:
          json['employeeId']?.toString() ??
          json['employeeCode']?.toString() ??
          (idStr.isNotEmpty ? 'EMP-$idStr' : ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'department': department,
      'avatarUrl': avatarUrl,
      'phoneNumber': phoneNumber,
      'employeeId': employeeId,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      role: entity.role,
      department: entity.department,
      avatarUrl: entity.avatarUrl,
      phoneNumber: entity.phoneNumber,
      employeeId: entity.employeeId,
    );
  }
}
