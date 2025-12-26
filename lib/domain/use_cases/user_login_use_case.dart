import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/core/utility/storage_path_service.dart';
import 'package:cross_platform_project/data/file_system_scan/fs_scan_handler.dart';
import 'package:cross_platform_project/domain/entities/user_entity.dart';
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
    if (loginResult.isSuccess) {
      await storage.init(
        currentUserId: ((loginResult as Success).data as UserEntity).id,
      );
      debugLog('storage initialized');
      await storage.ensureRootExists(
        userId: ((loginResult as Success).data as UserEntity).id,
      );
      debugLog('root should exist');
      debugLog('starting scan');
      await fsScanHandler.executeScan();
      debugLog('scan finished');
      debugLog('launching sync');
      storage.syncronize();
    }

    return loginResult;
  }
}
