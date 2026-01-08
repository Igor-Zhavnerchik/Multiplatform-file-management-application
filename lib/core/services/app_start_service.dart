import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/file_system_scan/fs_scanner_providers.dart';
import 'package:cross_platform_project/data/providers/providers.dart';
import 'package:cross_platform_project/data/providers/storage_repository_provider.dart';
import 'package:cross_platform_project/domain/providers/sync_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class AppStartService {
  final Ref ref;
  AppStartService({required this.ref});

  //FIXME: add error handling
  Future<Result<void>> onUserLogin() async {
    final storage = ref.read(storageRepositoryProvider);
    final fsScanHandler = ref.read(fsScanHandlerProvider);
    final fsWatcher = ref.read(fileSystemWatcherProvider);
    final sync = ref.read(syncRepositoryProvider);
    await storage.ensureRootExists();
    debugLog('starting scan');
    await fsScanHandler.executeScan();

    debugLog('launching fs watcher');
    fsWatcher.watchFS();
    debugLog('launching sync');
    sync.syncronizeAll();

    return Success(null);
  }

  Future<Result<void>> onAppStart() async {
    final pathService = ref.read(storagePathServiceProvider);
    pathService.init(
      appRootPath: (await getApplicationDocumentsDirectory()).path,
    );
    return Success(null);
  }
}
