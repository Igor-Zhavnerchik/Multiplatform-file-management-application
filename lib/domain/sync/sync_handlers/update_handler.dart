import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import 'package:cross_platform_project/data/repositories/requests/update_file_request.dart';
import 'package:cross_platform_project/domain/sync/sync_action_source/sync_action_source.dart';
import 'package:cross_platform_project/domain/sync/sync_processor.dart';
import 'package:cross_platform_project/domain/sync/sync_status_manager.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';

class UpdateHandler {
  SyncActionSource local;
  SyncActionSource remote;
  SyncStatusManager syncStatusManager;
  FileModelMapper mapper;

  UpdateHandler({
    required this.local,
    required this.remote,
    required this.syncStatusManager,
    required this.mapper,
  });

  Future<Result<void>> handle(SyncEvent event) async {
    final source = event.source == SyncSource.remote ? local : remote;

    await syncStatusManager.updateStatus(
      fileId: event.payload.id,
      status: event.source == SyncSource.remote
          ? SyncStatus.updatingLocally
          : SyncStatus.updatingRemotely,
    );
    debugLog('handling update event for ${event.payload.name}');
    final updateResult = await source.updateFile(
      request: mapper.toUpdateRequest(event.payload),
    );
    await syncStatusManager.updateStatus(
      fileId: event.payload.id,
      status: updateResult.isSuccess
          ? event.payload.deletedAt == null
                ? SyncStatus.syncronized
                : SyncStatus.deleted
          : event.source == SyncSource.remote
          ? SyncStatus.failedLocalUpdate
          : SyncStatus.failedRemoteUpdate,
    );

    return updateResult;
  }
}
