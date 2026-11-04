import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';

class UserNotifier {
  UserNotifier._();

  static const UserEntity defaultUser = UserEntity(
    id: 'USR-1002',
    name: 'Sarah Connor',
    email: 'sarah.connor@misteams.com',
    role: 'Senior Project Lead',
    department: 'Engineering & Operations',
    phoneNumber: '+1 (555) 019-2834',
    employeeId: 'EMP-9824',
    avatarUrl: null,
  );

  static final ValueNotifier<UserEntity> userNotifier =
      ValueNotifier<UserEntity>(defaultUser);

  static UserEntity get currentUser => userNotifier.value;

  static void updateUser(UserEntity updatedUser) {
    userNotifier.value = updatedUser;
  }
}
