import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/sync/sync_action_source/sync_action_source.dart';
import 'package:cross_platform_project/data/sync/sync_processor.dart';
import 'package:cross_platform_project/data/sync/sync_status_manager.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';

class UpdateHandler {
  SyncActionSource local;
  SyncActionSource remote;
  SyncStatusManager syncStatusManager;

  UpdateHandler({
    required this.local,
    required this.remote,
    required this.syncStatusManager,
  });

  Future<Result<void>> handle(SyncEvent event) async {
    final source = event.source == SyncSource.remote ? local : remote;

    await syncStatusManager.updateStatus(
      fileId: event.payload.id,
      status: event.source == SyncSource.remote
          ? SyncStatus.updatingLocally
          : SyncStatus.updatingRemotely,
    );
    final updateResult = await source.updateFile(model: event.payload);
    if (updateResult.isFailure) {
      await syncStatusManager.updateStatus(
        fileId: event.payload.id,
        status: event.source == SyncSource.remote
            ? SyncStatus.failedLocalUpdate
            : SyncStatus.failedRemoteUpdate,
      );
    }
    return updateResult;
  }
}
