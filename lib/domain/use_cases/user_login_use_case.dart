import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/core/utility/storage_path_service.dart';
import 'package:cross_platform_project/data/file_system_scan/fs_scan_handler.dart';
import 'package:cross_platform_project/domain/repositories/auth_repository.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';

class UserLoginUseCase {
  final AuthRepository auth;
  final StorageRepository storage;
  final FsScanHandler fsScanHandler;
  final StoragePathService pathService;

  UserLoginUseCase({
    required this.auth,
    required this.storage,
    required this.fsScanHandler,
    required this.pathService,
  });

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
        await fsScanHandler.executeScan();
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
