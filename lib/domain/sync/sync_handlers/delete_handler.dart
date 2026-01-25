import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import 'package:cross_platform_project/domain/sync/sync_action_source/sync_action_source.dart';
import 'package:cross_platform_project/domain/sync/sync_processor.dart';
import 'package:cross_platform_project/domain/sync/sync_status_manager.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';

class DeleteHandler {
  SyncActionSource local;
  SyncActionSource remote;
  SyncStatusManager syncStatusManager;
  FileModelMapper mapper;

  DeleteHandler({
    required this.local,
    required this.remote,
    required this.syncStatusManager,
    required this.mapper,
  });

  Future<Result<void>> handle(SyncEvent event) async {
    final Result<void> result;
    final FileEntity payload = switch (event.source) {
      SyncSource.local => event.localFile!,
      SyncSource.remote => event.remoteFile ?? event.localFile!,
    };
    if (event.source == SyncSource.remote) {
      await syncStatusManager.updateStatus(
        fileId: payload.id,
        status: SyncStatus.deletingLocally,
      );
      result = await local.deleteFile(
        model: mapper.fromEntity(payload),
        softDelete: false,
      );
      if (result.isFailure) {
        await syncStatusManager.updateStatus(
          fileId: payload.id,
          status: SyncStatus.failedLocalDelete,
        );
      }
    } else {
      await syncStatusManager.updateStatus(
        fileId: payload.id,
        status: SyncStatus.deletingRemotely,
      );
      final localResult = await local.deleteFile(
        model: mapper.fromEntity(payload),
        softDelete: false,
      );
      if (localResult.isFailure) {
        return localResult;
      }
      result = await remote.deleteFile(
        model: mapper.fromEntity(payload),
        softDelete: true,
      );
      if (result.isFailure) {
        await syncStatusManager.updateStatus(
          fileId: payload.id,
          status: SyncStatus.failedRemoteDelete,
        );
      }
    }
    return result;
  }
}
