import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import 'package:cross_platform_project/data/repositories/requests/update_file_request.dart';
import 'package:cross_platform_project/data/services/file_transfer_manager/file_transfer_manager.dart';
import 'package:cross_platform_project/domain/sync/sync_action_source/sync_action_source.dart';
import 'package:cross_platform_project/domain/sync/sync_processor.dart';
import 'package:cross_platform_project/domain/sync/sync_status_manager.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';

class UpdateHandler {
  SyncActionSource local;
  SyncActionSource remote;
  SyncStatusManager syncStatusManager;
  FileModelMapper mapper;
  FileTransferManager fileTransferManager;

  UpdateHandler({
    required this.local,
    required this.remote,
    required this.syncStatusManager,
    required this.mapper,
    required this.fileTransferManager,
  });

  Future<Result<void>> handle(SyncEvent event) async {
    final dest = event.source == SyncSource.remote ? local : remote;
    final localFile = event.localFile!;
    final remoteFile = event.remoteFile!;
    final syncContent =
        localFile.contentSyncEnabled &&
        (localFile.contentUpdatedAt != remoteFile.contentUpdatedAt) &&
        remoteFile.downloadStatus == DownloadStatus.downloaded;
    final isFromLocal = event.source == SyncSource.local;
    debugLog('for ${localFile.name} sync: $syncContent');
    if (localFile.updatedAt == remoteFile.updatedAt && !syncContent) {
      return Success(null);
    }
    final isUpload =
        isFromLocal &&
        localFile.contentUpdatedAt.isAfter(remoteFile.contentUpdatedAt);
    FileEntity payload = isFromLocal ? localFile : remoteFile;
    if (!syncContent) {
      payload = payload.copyWith(
        contentUpdatedAt: isFromLocal
            ? remoteFile.contentUpdatedAt
            : localFile.contentUpdatedAt,
        downloadStatus: !isFromLocal && syncContent
            ? DownloadStatus.haveNewVersion
            : localFile.downloadStatus,
      );
    } else {
      payload = payload.copyWith(
        contentUpdatedAt: isUpload
            ? localFile.contentUpdatedAt
            : remoteFile.contentUpdatedAt,
        downloadStatus: isUpload ? DownloadStatus.notDownloaded : null,
      );
    }
    Result<void> updateResult = Success(null);

    debugLog('handling update event for ${localFile.name}');
    if (localFile.updatedAt != remoteFile.updatedAt) {
      await syncStatusManager.updateStatus(
        fileId: payload.id,
        status: isFromLocal
            ? SyncStatus.updatedRemotely
            : SyncStatus.updatingLocally,
      );
      updateResult = await dest.updateFile(
        request: mapper.toUpdateRequest(mapper.fromEntity(payload)),
      );
    }

    if (syncContent) {
      fileTransferManager.addTransferEvent(
        action: isUpload ? TransferAction.upload : TransferAction.download,
        payload: mapper.fromEntity(payload),
      );
    }
    await syncStatusManager.updateStatus(
      fileId: payload.id,
      status: updateResult.isSuccess
          ? SyncStatus.syncronized
          : isFromLocal
          ? SyncStatus.failedRemoteUpdate
          : SyncStatus.failedLocalUpdate,
    );

    return updateResult;
  }
}
