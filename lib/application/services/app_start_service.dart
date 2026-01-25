import 'package:cross_platform_project/application/fs_scan/providers/fs_scan_handler_provider.dart';
import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/application/providers/settings_service_provider.dart';
import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/data/file_system/fs_scanner_providers.dart';
import 'package:cross_platform_project/data/providers/local_data_source_providers.dart';
import 'package:cross_platform_project/data/repositories/providers/auth_repository_provider.dart';
import 'package:cross_platform_project/data/repositories/providers/storage_repository_provider.dart';
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
    final settings = ref.read(settingsServiceProvider);
    final auth = ref.read(authRepositoryProvider);

    await auth.ensureUserEntryExists();
    await storage.ensureRootExists();
    settings.init();
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
