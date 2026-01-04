import 'package:cross_platform_project/data/providers/remote_sync_event_listener_provider.dart';
import 'package:cross_platform_project/data/providers/storage_repository_provider.dart';
import 'package:cross_platform_project/data/repositories/sync_repository_impl.dart';
import 'package:cross_platform_project/data/sync/providers/sync_providers.dart';
import 'package:cross_platform_project/domain/repositories/sync_repositry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  final storage = ref.watch(storageRepositoryProvider);
  final syncProcessor = ref.watch(syncProcessorProvider);
  final syncStatusManager = ref.watch(syncStatusManagerProvider);
  final remoteSyncEventlistener = ref.watch(remoteSyncEventListenerProvider);
  return SyncRepositoryImpl(
    storage: storage,
    syncProcessor: syncProcessor,
    syncStatusManager: syncStatusManager,
    remoteSyncEventListener: remoteSyncEventlistener,
  );
});
