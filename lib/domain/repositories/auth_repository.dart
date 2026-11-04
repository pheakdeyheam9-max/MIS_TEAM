import '../../core/network/api_client.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<ApiResult<UserEntity>> login(String username, String password);
  Future<ApiResult<bool>> resetPassword(String email);
  Future<ApiResult<UserEntity>> getCurrentUser();
  Future<ApiResult<UserEntity>> updateProfile(UserEntity user);
  Future<ApiResult<bool>> changePassword(
    String currentPassword,
    String newPassword,
  );
  Future<void> logout();
}
