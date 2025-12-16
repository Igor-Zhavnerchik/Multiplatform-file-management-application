import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/domain/repositories/auth_repository.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';

class UserLoginUseCase {
  final AuthRepository auth;
  final StorageRepository storage;

  UserLoginUseCase({required this.auth, required this.storage});

  Future<bool> call({
    required String email,
    required String password,
    required bool saveOnThisDevice,
  }) async {
    var successfulLogin = await auth.signIn(
      email: email,
      password: password,
      saveOnThisDevice: saveOnThisDevice,
    );
    if (successfulLogin) {
      await storage.init();
      try {
        await storage.syncronize();
        final userStateResult = await storage.createUserSaveState();
        if (userStateResult.isFailure) {
          return false;
        }
      } catch (e) {
        print(e);
      }
    }

    return successfulLogin;
  }
}
