import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/services/storage_path_service.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/file_system_scan/file_system_watcher.dart';
import 'package:cross_platform_project/data/file_system_scan/fs_scan_handler.dart';
import 'package:cross_platform_project/data/providers/providers.dart';
import 'package:cross_platform_project/data/providers/storage_repository_provider.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class AppStartService {
  final FileSystemWatcher fsWatcher;
  final FsScanHandler fsScanHandler;
  final StoragePathService pathService;
  final StorageRepository storage;
  final Ref ref;
  AppStartService({
    required this.fsWatcher,
    required this.fsScanHandler,
    required this.pathService,
    required this.storage,
    required this.ref,
  });

  void resetAppState() {
    ref.invalidate(storagePathServiceProvider);
    ref.invalidate(storageRepositoryProvider);
    ref.read(storagePathServiceProvider);
    ref.read(storageRepositoryProvider);
  }

  //FIXME: add error handling
  Future<Result<void>> onUserLogin({required String userId}) async {
    resetAppState();
    pathService.init(
      userId: userId,
      appRootPath: (await getApplicationDocumentsDirectory()).path,
    );
    storage.init(userId: userId);
    debugLog('storage initialized');
    await storage.ensureRootExists();
    debugLog('starting scan');
    //await fsScanHandler.executeScan();

    debugLog('launching fs watcher');
    fsWatcher.watchFS();
    debugLog('launching sync');
    storage.syncronize();

    return Success(null);
  }

  Future<Result<void>> onAppStart() async {
    return Success(null);
  }
}
