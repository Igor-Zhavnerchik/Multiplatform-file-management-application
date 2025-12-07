import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/sync/sync_action_source/sync_action_source.dart';
import 'package:cross_platform_project/data/sync/sync_processor.dart';
import 'package:cross_platform_project/data/sync/sync_status_manager.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';

class LoadHandler {
  SyncActionSource local;
  SyncActionSource remote;
  SyncStatusManager syncStatusManager;

  LoadHandler({
    required this.local,
    required this.remote,
    required this.syncStatusManager,
  });

  Future<Result<void>> handle(SyncEvent event) async {
    final src = event.source == SyncSource.remote ? local : remote;
    final dest = event.source == SyncSource.remote ? local : remote;
    await syncStatusManager.updateStatus(
      model: event.payload,
      status: event.source == SyncSource.remote
          ? SyncStatus.downloading
          : SyncStatus.uploading,
    );
    final dataResult = await src.readFile(model: event.payload);
    if (dataResult.isFailure) {
      syncStatusManager.updateStatus(
        model: event.payload,
        status: event.source == SyncSource.remote
            ? SyncStatus.failedDownload
            : SyncStatus.failedUpload,
      );
      return dataResult;
    }

    final saveResult = await dest.writeFile(
      model: event.payload,
      data: (dataResult as Success).data,
    );
    if (saveResult.isFailure) {
      await syncStatusManager.updateStatus(
        model: event.payload,
        status: event.source == SyncSource.remote
            ? SyncStatus.failedDownload
            : SyncStatus.failedUpload,
      );
      return saveResult;
    }
    await syncStatusManager.updateStatus(
      model: event.payload,
      status: SyncStatus.syncronized,
    );
    return Success(null);
  }
}
