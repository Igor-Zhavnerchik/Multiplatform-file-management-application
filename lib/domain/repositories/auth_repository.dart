import 'package:cross_platform_project/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> getCurrentUser();
  Future<bool> signIn({
    required String email,
    required String password,
    required bool saveOnThisDevice,
  });
  Future<void> signOut();
  Future<bool> registerUser({required String email, required String password});
}
