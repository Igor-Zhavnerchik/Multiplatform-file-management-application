import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/services/storage_path_service.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/file_system_scan/file_system_watcher.dart';
import 'package:cross_platform_project/data/file_system_scan/fs_scan_handler.dart';
import 'package:cross_platform_project/data/services/current_user_provider.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';
import 'package:path_provider/path_provider.dart';

class AppStartService {
  final FileSystemWatcher fsWatcher;
  final FsScanHandler fsScanHandler;
  final StoragePathService pathService;
  final StorageRepository storage;
  final CurrentUserProvider currentUserProvider;
  AppStartService({
    required this.fsWatcher,
    required this.fsScanHandler,
    required this.pathService,
    required this.storage,
    required this.currentUserProvider,
  });

  //FIXME: add error handling
  Future<Result<void>> onUserLogin() async {
    pathService.init(
      currentUserId: currentUserProvider.currentUserId!,
      appRootPath: (await getApplicationDocumentsDirectory()).path,
    );
    await storage.init(currentUserId: currentUserProvider.currentUserId!);

    debugLog('storage initialized');
    await storage.ensureRootExists();
    debugLog('launching fs watcher');
    fsWatcher.watchFS();
    debugLog('starting scan');
    await fsScanHandler.executeScan();
    debugLog('launching sync');
    storage.syncronize();

    return Success(null);
  }
}
