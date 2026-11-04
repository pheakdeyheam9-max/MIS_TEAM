class EmployeeEntity {
  final String id;
  final String employeeId;
  final String name;
  final String email;
  final String role;
  final String department;
  final String phoneNumber;
  final String status; // Active, On Leave, Inactive
  final String? avatarUrl;
  final String? joinDate;

  // Backend fields
  final String? firstName;
  final String? lastName;
  final double? salary;
  final String? gender;
  final String? dateOfBirth;
  final String? address;

  const EmployeeEntity({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    required this.phoneNumber,
    this.status = 'Active',
    this.avatarUrl,
    this.joinDate,
    this.firstName,
    this.lastName,
    this.salary,
    this.gender,
    this.dateOfBirth,
    this.address,
  });

  String get initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'E';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }

  EmployeeEntity copyWith({
    String? id,
    String? employeeId,
    String? name,
    String? email,
    String? role,
    String? department,
    String? phoneNumber,
    String? status,
    String? avatarUrl,
    String? joinDate,
    String? firstName,
    String? lastName,
    double? salary,
    String? gender,
    String? dateOfBirth,
    String? address,
  }) {
    return EmployeeEntity(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      department: department ?? this.department,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      joinDate: joinDate ?? this.joinDate,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      salary: salary ?? this.salary,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
    );
  }
}
