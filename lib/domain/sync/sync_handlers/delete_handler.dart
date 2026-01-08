import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/domain/sync/sync_action_source/sync_action_source.dart';
import 'package:cross_platform_project/domain/sync/sync_processor.dart';
import 'package:cross_platform_project/domain/sync/sync_status_manager.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';

class DeleteHandler {
  SyncActionSource local;
  SyncActionSource remote;
  SyncStatusManager syncStatusManager;

  DeleteHandler({
    required this.local,
    required this.remote,
    required this.syncStatusManager,
  });

  Future<Result<void>> handle(SyncEvent event) async {
    final Result<void> result;
    if (event.source == SyncSource.remote) {
      await syncStatusManager.updateStatus(
        fileId: event.payload.id,
        status: SyncStatus.deletingLocally,
      );
      result = await local.deleteFile(model: event.payload, softDelete: false);
      if (result.isFailure) {
        await syncStatusManager.updateStatus(
          fileId: event.payload.id,
          status: SyncStatus.failedLocalDelete,
        );
      }
    } else {
      await syncStatusManager.updateStatus(
        fileId: event.payload.id,
        status: SyncStatus.deletingRemotely,
      );
      final localResult = await local.deleteFile(
        model: event.payload,
        softDelete: false,
      );
      if (localResult.isFailure) {
        return localResult;
      }
      result = await remote.deleteFile(model: event.payload, softDelete: true);
      if (result.isFailure) {
        await syncStatusManager.updateStatus(
          fileId: event.payload.id,
          status: SyncStatus.failedRemoteDelete,
        );
      }
    }
    return result;
  }
}
