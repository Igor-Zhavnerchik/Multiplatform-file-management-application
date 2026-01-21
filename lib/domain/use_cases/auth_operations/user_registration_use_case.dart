import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/domain/repositories/auth_repository.dart';

class UserRegistrationUseCase {
  final AuthRepository auth;

  UserRegistrationUseCase({required this.auth});

  Future<Result<void>> call({
    required String email,
    required String password,
  }) async {
    final userResult = await auth.registerUser(
      email: email,
      password: password,
    );
    return userResult;
  }
}
