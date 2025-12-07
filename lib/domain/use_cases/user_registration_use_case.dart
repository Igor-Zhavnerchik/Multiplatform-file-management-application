import 'package:cross_platform_project/domain/repositories/auth_repository.dart';

class UserRegistrationUseCase {
  final AuthRepository auth;

  UserRegistrationUseCase({required this.auth});

  Future<bool> call({required String email, required String password}) async {
    return await auth.registerUser(email: email, password: password);
  }
}
