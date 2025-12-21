import 'package:cross_platform_project/data/data_source/local/database/database_providers.dart';
import 'package:cross_platform_project/data/data_source/local/local_file_id_service.dart/local_file_id_serivde_provider.dart';
import 'package:cross_platform_project/data/file_system_scan/db_updater.dart';
import 'package:cross_platform_project/data/file_system_scan/file_system_scanner.dart';
import 'package:cross_platform_project/data/file_system_scan/file_system_watcher.dart';
import 'package:cross_platform_project/data/file_system_scan/fs_scan_handler.dart';
import 'package:cross_platform_project/data/file_system_scan/reconciler.dart';
import 'package:cross_platform_project/data/providers/file_model_mapper_provider.dart';
import 'package:cross_platform_project/data/providers/hash_service_provider.dart';
import 'package:cross_platform_project/data/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fileSystemScannerProvider = Provider<FileSystemScanner>((ref) {
  final localFileIdService = ref.watch(localFileIdServiceProvider);
  final pathService = ref.watch(storagePathServiceProvider);
  return FileSystemScanner(
    localFileIdService: localFileIdService,
    pathService: pathService,
  );
});
final fileSystemWatcherProvider = Provider<FileSystemWatcher>((ref) {
  final pathService = ref.watch(storagePathServiceProvider);
  return FileSystemWatcher(pathService: pathService);
});
final reconcilerProvider = Provider<Reconciler>((ref) {
  final hashService = ref.watch(hashServiceProvider);
  final pathService = ref.watch(storagePathServiceProvider);
  return Reconciler(hashService: hashService, pathService: pathService);
});
final dbUpdaterProvider = Provider<DbUpdater>((ref) {
  final pathService = ref.watch(storagePathServiceProvider);
  final filesTable = ref.watch(filesTableProvider);
  final mapper = ref.watch(fileModelMapperProvider);
  return DbUpdater(
    filesTable: filesTable,
    mapper: mapper,
    pathService: pathService,
  );
});

final fsScanHandlerProvider = Provider<FsScanHandler>((ref) {
  final scanner = ref.watch(fileSystemScannerProvider);
  final reconciler = ref.watch(reconcilerProvider);
  final updater = ref.watch(dbUpdaterProvider);
  final filesTable = ref.watch(filesTableProvider);
  final mapper = ref.watch(fileModelMapperProvider);
  return FsScanHandler(
    scanner: scanner,
    reconciler: reconciler,
    updater: updater,
    filesTable: filesTable,
    mapper: mapper,
  );
});
