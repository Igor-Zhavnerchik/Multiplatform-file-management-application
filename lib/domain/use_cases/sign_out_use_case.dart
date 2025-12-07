import 'package:cross_platform_project/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository auth;

  SignOutUseCase({required this.auth});

  Future<void> call() async {
    await auth.signOut();
  }
}
