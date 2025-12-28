import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/domain/repositories/auth_repository.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';

class UserRegistrationUseCase {
  final AuthRepository auth;
  final StorageRepository storage;

  UserRegistrationUseCase({required this.auth, required this.storage});

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
