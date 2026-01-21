import 'package:cross_platform_project/application/fs_scan/fs_scan_handler_provider.dart';
import 'package:cross_platform_project/data/data_source/local/local_file_id_service.dart/local_file_id_serivde_provider.dart';
import 'package:cross_platform_project/data/file_system/file_system_scanner.dart';
import 'package:cross_platform_project/data/file_system/file_system_watcher.dart';
import 'package:cross_platform_project/data/providers/local_data_source_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fileSystemScannerProvider = Provider.autoDispose<FileSystemScanner>((
  ref,
) {
  final localFileIdService = ref.watch(localFileIdServiceProvider);
  final pathService = ref.watch(storagePathServiceProvider);
  return FileSystemScanner(
    localFileIdService: localFileIdService,
    pathService: pathService,
  );
});
final fileSystemWatcherProvider = Provider.autoDispose<FileSystemWatcher>((
  ref,
) {
  final pathService = ref.watch(storagePathServiceProvider);
  final scanHandler = ref.watch(fsScanHandlerProvider);
  final watcher = FileSystemWatcher(
    pathService: pathService,
    scanHandler: scanHandler,
  );
  ref.onDispose(() => watcher.dispose());
  return watcher;
});
