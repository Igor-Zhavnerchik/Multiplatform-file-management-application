import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/services/app_start_service.dart';
import 'package:cross_platform_project/data/file_system_scan/fs_scanner_providers.dart';
import 'package:cross_platform_project/data/providers/local_data_source_providers.dart';
import 'package:cross_platform_project/data/providers/storage_repository_provider.dart';
import 'package:cross_platform_project/domain/providers/sync_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appStartServiceProvider = Provider<AppStartService>((ref) {
  debugLog('reading appStartServiceprovider');
  final fsWatcher = ref.read(fileSystemWatcherProvider);
  debugLog('after watcher befor scanner');
  final fsScanHandler = ref.read(fsScanHandlerProvider);
  final pathService = ref.read(storagePathServiceProvider);
  final storage = ref.read(storageRepositoryProvider);
  final sync = ref.read(syncRepositoryProvider);
  debugLog('returning service');
  return AppStartService(
    fsWatcher: fsWatcher,
    fsScanHandler: fsScanHandler,
    pathService: pathService,
    storage: storage,
    ref: ref,
    sync: sync,
  );
});
