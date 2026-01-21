import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/services/file_transfer_manager/file_transfer_manager.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/sync/sync_action_source/sync_action_source.dart';
import 'package:cross_platform_project/domain/sync/sync_processor.dart';
import 'package:cross_platform_project/domain/sync/sync_status_manager.dart';

class CreateHandler {
  SyncActionSource local;
  SyncActionSource remote;
  SyncStatusManager syncStatusManager;
  FileTransferManager fileTransferManager;

  CreateHandler({
    required this.local,
    required this.remote,
    required this.syncStatusManager,
    required this.fileTransferManager,
  });

  Future<Result<void>> handle(SyncEvent event) async {
    late final SyncActionSource dest;
    FileModel payload;
    final bool isFromLocal = event.source == SyncSource.local;
    if (isFromLocal) {
      dest = remote;
      payload = event.localFile!;
    } else {
      dest = local;
      payload = event.remoteFile!;
    }
    final syncEnabled = payload.contentSyncEnabled;
    payload = payload.copyWith(
      contentUpdatedAt: syncEnabled
          ? payload.contentUpdatedAt
          : DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
    );

    final createResult = await dest.writeFile(model: payload);

    if (syncEnabled) {
      fileTransferManager.addTransferEvent(
        action: isFromLocal ? TransferAction.upload : TransferAction.download,
        payload: payload,
      );
    }
    if (isFromLocal) {
      syncStatusManager.updateStatus(
        fileId: payload.id,
        status: createResult.isSuccess
            ? SyncStatus.syncronized
            : SyncStatus.failedRemoteCreate,
      );
    }

    return createResult;
  }
}
