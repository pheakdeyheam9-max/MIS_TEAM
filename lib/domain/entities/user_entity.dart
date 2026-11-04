class UserEntity {
  final String id;
  final String name;
  final String email;
  final String role;
  final String department;
  final String? avatarUrl;
  final String phoneNumber;
  final String employeeId;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    this.avatarUrl,
    required this.phoneNumber,
    required this.employeeId,
  });

  String get initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'U';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }
}
