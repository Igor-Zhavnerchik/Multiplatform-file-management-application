import 'package:cross_platform_project/application/providers/db_snapshot_getter_provider.dart';
import 'package:cross_platform_project/data/data_source/local/local_file_id_service.dart/local_file_id_serivde_provider.dart';
import 'package:cross_platform_project/data/file_system_scan/fs_change_applier.dart';
import 'package:cross_platform_project/data/file_system_scan/file_system_scanner.dart';
import 'package:cross_platform_project/data/file_system_scan/file_system_watcher.dart';
import 'package:cross_platform_project/data/file_system_scan/fs_scan_handler.dart';
import 'package:cross_platform_project/data/file_system_scan/reconciler.dart';
import 'package:cross_platform_project/data/models/providers/file_model_mapper_provider.dart';
import 'package:cross_platform_project/data/services/providers/hash_service_provider.dart';
import 'package:cross_platform_project/data/providers/local_data_source_providers.dart';
import 'package:cross_platform_project/data/repositories/providers/storage_repository_provider.dart';
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
  final watcher = FileSystemWatcher(pathService: pathService);
  ref.onDispose(() => watcher.dispose());
  return watcher;
});
final reconcilerProvider = Provider.autoDispose<Reconciler>((ref) {
  final hashService = ref.watch(hashServiceProvider);
  final pathService = ref.watch(storagePathServiceProvider);
  final localDataSource = ref.watch(localDataSourceProvider);
  return Reconciler(
    hashService: hashService,
    pathService: pathService,
    localDataSource: localDataSource,
  );
});
final fsChangeApplierProvider = Provider.autoDispose<FsChangeApplier>((ref) {
  final pathService = ref.watch(storagePathServiceProvider);
  final localDataSource = ref.watch(localDataSourceProvider);
  final mapper = ref.watch(fileModelMapperProvider);
  final storage = ref.watch(storageRepositoryProvider);
  return FsChangeApplier(
    localDataSource: localDataSource,
    mapper: mapper,
    pathService: pathService,
    storage: storage,
  );
});

final fsScanHandlerProvider = Provider.autoDispose<FsScanHandler>((ref) {
  final scanner = ref.watch(fileSystemScannerProvider);
  final reconciler = ref.watch(reconcilerProvider);
  final changeApplier = ref.watch(fsChangeApplierProvider);
  final dbSnapshotGetter = ref.watch(dbSnapshotGetterProvider);
  return FsScanHandler(
    scanner: scanner,
    reconciler: reconciler,
    changeApplier: changeApplier,
    dbSnapshotGetter: dbSnapshotGetter,
  );
});
