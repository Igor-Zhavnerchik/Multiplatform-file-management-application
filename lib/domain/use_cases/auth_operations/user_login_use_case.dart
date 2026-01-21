import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/domain/entities/user_entity.dart';
import 'package:cross_platform_project/domain/repositories/auth_repository.dart';

class UserLoginUseCase {
  final AuthRepository auth;

  UserLoginUseCase({required this.auth});

  Future<Result<UserEntity>> call({
    required String email,
    required String password,
    required bool saveOnThisDevice,
  }) async {
    final loginResult = await auth.signIn(
      email: email,
      password: password,
      saveOnThisDevice: saveOnThisDevice,
    );
    return loginResult;
  }
}
