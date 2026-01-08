import 'package:cross_platform_project/data/data_source/local/database/database_providers.dart';
import 'package:cross_platform_project/data/providers/providers.dart';
import 'package:cross_platform_project/domain/sync/sync_action_source/local_sync_action_source.dart';
import 'package:cross_platform_project/domain/sync/sync_action_source/remote_sync_action_source.dart';
import 'package:cross_platform_project/domain/sync/sync_action_source/sync_action_source.dart';
import 'package:cross_platform_project/domain/sync/sync_handlers/delete_handler.dart';
import 'package:cross_platform_project/domain/sync/sync_handlers/load_handler.dart';
import 'package:cross_platform_project/domain/sync/sync_handlers/update_handler.dart';
import 'package:cross_platform_project/domain/sync/sync_processor.dart';
import 'package:cross_platform_project/domain/sync/sync_status_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final syncStatusManagerProvider = Provider<SyncStatusManager>((ref) {
  final filesTable = ref.watch(filesTableProvider);
  return SyncStatusManager(filesTable: filesTable);
});

final localSyncActionSourceProvider = Provider<SyncActionSource>((ref) {
  final localDataSource = ref.watch(localDataSourceProvider);
  return LocalSyncActionSource(localDataSource: localDataSource);
});

final remoteSyncActionSourceProvider = Provider<SyncActionSource>((ref) {
  final remoteDataSource = ref.watch(remoteDataSourceProvider);
  return RemoteSyncActionSource(remoteDataSource: remoteDataSource);
});

final updateHandlerProvider = Provider<UpdateHandler>((ref) {
  final localSyncActionSource = ref.watch(localSyncActionSourceProvider);
  final remoteSyncActionSource = ref.watch(remoteSyncActionSourceProvider);
  final syncStatusManager = ref.watch(syncStatusManagerProvider);
  return UpdateHandler(
    local: localSyncActionSource,
    remote: remoteSyncActionSource,
    syncStatusManager: syncStatusManager,
  );
});

final loadHandlerProvider = Provider<LoadHandler>((ref) {
  final localSyncActionSource = ref.watch(localSyncActionSourceProvider);
  final remoteSyncActionSource = ref.watch(remoteSyncActionSourceProvider);
  final syncStatusManager = ref.watch(syncStatusManagerProvider);
  return LoadHandler(
    local: localSyncActionSource,
    remote: remoteSyncActionSource,
    syncStatusManager: syncStatusManager,
  );
});

final deleteHandlerProvider = Provider<DeleteHandler>((ref) {
  final localSyncActionSource = ref.watch(localSyncActionSourceProvider);
  final remoteSyncActionSource = ref.watch(remoteSyncActionSourceProvider);
  final syncStatusManager = ref.watch(syncStatusManagerProvider);
  return DeleteHandler(
    local: localSyncActionSource,
    remote: remoteSyncActionSource,
    syncStatusManager: syncStatusManager,
  );
});

final syncProcessorProvider = Provider<SyncProcessor>((ref) {
  final updateHandler = ref.watch(updateHandlerProvider);
  final loadHandler = ref.watch(loadHandlerProvider);
  final deleteHandler = ref.watch(deleteHandlerProvider);

  return SyncProcessor(
    updateHandler: updateHandler,
    loadHandler: loadHandler,
    deleteHandler: deleteHandler,
  );
});
