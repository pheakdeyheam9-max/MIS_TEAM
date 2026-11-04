import '../../domain/entities/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required super.id,
    required super.employeeId,
    required super.name,
    required super.email,
    required super.role,
    required super.department,
    required super.phoneNumber,
    super.status,
    super.avatarUrl,
    super.joinDate,
    super.firstName,
    super.lastName,
    super.salary,
    super.gender,
    super.dateOfBirth,
    super.address,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id']?.toString() ?? '';
    final code =
        json['employeeCode']?.toString() ??
        json['employeeId']?.toString() ??
        '';
    final fName = json['firstName']?.toString();
    final lName = json['lastName']?.toString();

    String fullName = json['name']?.toString() ?? '';
    if (fName != null || lName != null) {
      fullName = '${fName ?? ''} ${lName ?? ''}'.trim();
    }

    String mappedStatus = 'Active';
    final rawStatus = json['status']?.toString().toUpperCase();
    if (rawStatus == 'ACT') {
      mappedStatus = 'Active';
    } else if (rawStatus == 'INA') {
      mappedStatus = 'Inactive';
    } else if (json['status'] != null) {
      mappedStatus = json['status'].toString();
    }

    return EmployeeModel(
      id: rawId,
      employeeId: code.isNotEmpty
          ? code
          : (rawId.isNotEmpty ? 'EMP-$rawId' : ''),
      name: fullName,
      email: json['email']?.toString() ?? '',
      role: json['position']?.toString() ?? json['role']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      phoneNumber:
          json['phoneNumber']?.toString() ?? json['phone']?.toString() ?? '',
      status: mappedStatus,
      avatarUrl: json['photoUrl']?.toString() ?? json['avatarUrl']?.toString(),
      joinDate: json['hireDate']?.toString() ?? json['joinDate']?.toString(),
      firstName: fName,
      lastName: lName,
      salary: (json['salary'] as num?)?.toDouble(),
      gender: json['gender']?.toString(),
      dateOfBirth: json['dateOfBirth']?.toString(),
      address: json['address']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    String fName = firstName ?? '';
    String lName = lastName ?? '';
    if (fName.isEmpty && lName.isEmpty && name.isNotEmpty) {
      final parts = name.trim().split(RegExp(r'\s+'));
      if (parts.length == 1) {
        fName = parts[0];
        lName = '';
      } else {
        fName = parts.first;
        lName = parts.sublist(1).join(' ');
      }
    }

    String backendStatus = 'ACT';
    if (status == 'Inactive' || status == 'INA') {
      backendStatus = 'INA';
    } else if (status == 'Active' || status == 'ACT') {
      backendStatus = 'ACT';
    } else {
      backendStatus = status;
    }

    final map = <String, dynamic>{
      'employeeCode': employeeId,
      'firstName': fName,
      'lastName': lName,
      'gender': gender ?? 'MALE',
      'dateOfBirth': dateOfBirth,
      'email': email,
      'phoneNumber': phoneNumber,
      'position': role,
      'department': department,
      'salary': salary ?? 500.0,
      'hireDate': joinDate ?? DateTime.now().toString().split(' ')[0],
      'address': address,
      'photoUrl': avatarUrl,
      'status': backendStatus,
    };
    if (id.isNotEmpty && int.tryParse(id) != null) {
      map['id'] = int.parse(id);
    }
    return map;
  }

  factory EmployeeModel.fromEntity(EmployeeEntity entity) {
    return EmployeeModel(
      id: entity.id,
      employeeId: entity.employeeId,
      name: entity.name,
      email: entity.email,
      role: entity.role,
      department: entity.department,
      phoneNumber: entity.phoneNumber,
      status: entity.status,
      avatarUrl: entity.avatarUrl,
      joinDate: entity.joinDate,
      firstName: entity.firstName,
      lastName: entity.lastName,
      salary: entity.salary,
      gender: entity.gender,
      dateOfBirth: entity.dateOfBirth,
      address: entity.address,
    );
  }
}
