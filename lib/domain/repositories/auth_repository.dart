import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/domain/entities/user_entity.dart';

abstract class AuthRepository {
  UserEntity? getCurrentUser();
  Future<Result<UserEntity>> signIn({
    required String email,
    required String password,
    required bool saveOnThisDevice,
  });
  Future<void> signOut();
  Future<Result<UserEntity>> registerUser({
    required String email,
    required String password,
  });
}
