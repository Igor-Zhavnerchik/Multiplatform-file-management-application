import 'package:cross_platform_project/data/models/providers/file_model_mapper_provider.dart';
import 'package:cross_platform_project/data/providers/local_data_source_providers.dart';
import 'package:cross_platform_project/data/providers/remote_data_source_providers.dart';
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
  final localDataSource = ref.watch(localDataSourceProvider);
  return SyncStatusManager(localDataSource: localDataSource);
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
  final mapper = ref.watch(fileModelMapperProvider);
  return UpdateHandler(
    local: localSyncActionSource,
    remote: remoteSyncActionSource,
    syncStatusManager: syncStatusManager,
    mapper: mapper,
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
