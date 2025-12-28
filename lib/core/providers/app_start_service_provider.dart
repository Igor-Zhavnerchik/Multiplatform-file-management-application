import 'package:cross_platform_project/core/services/app_start_service.dart';
import 'package:cross_platform_project/data/file_system_scan/fs_scanner_providers.dart';
import 'package:cross_platform_project/data/providers/current_user_provider.dart';
import 'package:cross_platform_project/data/providers/local_data_source_providers.dart';
import 'package:cross_platform_project/data/providers/storage_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appStartServiceProvider = Provider<AppStartService>((ref) {
  final fsWatcher = ref.watch(fileSystemWatcherProvider);
  final fsScanHandler = ref.watch(fsScanHandlerProvider);
  final pathService = ref.watch(storagePathServiceProvider);
  final storage = ref.watch(storageRepositoryProvider);
  final currentUser = ref.watch(currentUserProvider);
  return AppStartService(
    fsWatcher: fsWatcher,
    fsScanHandler: fsScanHandler,
    pathService: pathService,
    storage: storage,
    currentUserProvider: currentUser,
  );
});
