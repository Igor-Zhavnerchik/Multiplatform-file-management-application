import 'dart:async';

import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/data/data_source/remote/remote_sync_event_listener.dart';
import 'package:cross_platform_project/domain/sync/sync_processor.dart';
import 'package:cross_platform_project/domain/sync/sync_status_manager.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';
import 'package:cross_platform_project/domain/repositories/sync_repositry.dart';

class SyncRepositoryImpl implements SyncRepository {
  final StorageRepository storage;
  final SyncStatusManager syncStatusManager;
  final SyncProcessor syncProcessor;
  final RemoteSyncEventListener remoteSyncEventListener;
  StreamSubscription<SyncEvent>? _remoteStreamSubscription;
  StreamSubscription<SyncEvent>? _localStreamSubscription;

  SyncRepositoryImpl({
    required this.storage,
    required this.syncProcessor,
    required this.syncStatusManager,
    required this.remoteSyncEventListener,
  });

  @override
  Future<Result<void>> syncronizeAll() async {
    debugLog('started sync all');
    final remoteFileListResult = await storage.getRemoteFileList();
    if (remoteFileListResult.isFailure) {
      final f = remoteFileListResult as Failure;
      debugLog(
        'failed getting remote file list: ${f.message} error: ${f.error}  source: ${f.source} ',
      );
      return remoteFileListResult;
    }
    final localFileListResult = await storage.getLocalFileList();
    if (localFileListResult.isFailure) {
      final f = remoteFileListResult as Failure;
      debugLog(
        'failed getting local file list: ${f.message} error: ${f.error}  source: ${f.source} ',
      );
      return localFileListResult;
    }
    debugLog('sync all: got file lists');

    final List<FileEntity> remoteFileList =
        (remoteFileListResult as Success).data;
    final List<FileEntity> localFileList =
        (localFileListResult as Success).data;
    debugLog('local:');
    for (var file in localFileList) {
      debugLog('    ${file.name}');
    }
    debugLog('remote:');
    for (var file in remoteFileList) {
      debugLog('    ${file.name}');
    }

    final Map<String, FileEntity> remoteMap = {};
    final Map<String, FileEntity> localMap = {};
    for (var remoteFile in remoteFileList) {
      remoteMap[remoteFile.id] = remoteFile;
    }
    for (var localFile in localFileList) {
      localMap[localFile.id] = localFile;
    }
    final Set fileIds = {};
    fileIds.addAll(remoteMap.keys);
    fileIds.addAll(localMap.keys);

    for (var fileId in fileIds) {
      switch ((localMap[fileId], remoteMap[fileId])) {
        case (FileEntity localModel, null):
          await _handleLocalOnly(localModel: localModel);
        case (null, FileEntity remoteModel):
          await _handleRemoteOnly(remoteModel: remoteModel);
        case (FileEntity localModel, FileEntity remoteModel):
          await _handleIntersection(
            localModel: localModel,
            remoteModel: remoteModel,
          );
      }
    }
    if (_remoteStreamSubscription == null) {
      remoteSyncEventListener.listenRemoteEvents();
      _remoteStreamSubscription = remoteSyncEventListener.syncEventStream
          .listen((event) async {
            debugLog('sync repository: catched remote ${event.action} event');
            final payload = event.remoteFile!;
            final localFile = await storage.getFileEntitybyId(id: payload.id);

            if (switch (event.action) {
              SyncAction.create => localFile == null,
              SyncAction.delete => localFile != null,
              SyncAction.update =>
                (localFile != null &&
                    localFile.updatedAt.isBefore(payload.updatedAt)),
            }) {
              syncProcessor.addEvent(
                event: event.copyWith(localFile: localFile),
              );
            }
          }, onError: (e) => debugLog('Error in sync stream: $e'));
    }
    _localStreamSubscription ??= storage.localSyncEventStream.listen((
      event,
    ) async {
      final payload = event.localFile!;
      debugLog('sync repository: catched local ${event.action} event');
      if (event.action == SyncAction.update) {
        final remoteFile = await storage.getRemoteEntity(id: payload.id);
        event = event.copyWith(remoteFile: remoteFile!);
      }
      syncProcessor.addEvent(event: event);
    });

    return Success(null);
  }

  Future<void> _handleRemoteOnly({required FileEntity remoteModel}) async {
    syncProcessor.addEvent(
      event: SyncEvent(
        action: SyncAction.create,
        source: SyncSource.remote,
        remoteFile: remoteModel,
        localFile: null,
      ),
    );
  }

  Future<void> _handleLocalOnly({required FileEntity localModel}) async {
    switch (localModel.syncStatus) {
      case SyncStatus.created || SyncStatus.failedRemoteCreate:
        syncProcessor.addEvent(
          event: SyncEvent(
            action: SyncAction.create,
            source: SyncSource.local,
            localFile: localModel,
            remoteFile: null,
          ),
        );
      case SyncStatus.syncronized ||
          SyncStatus.deleted ||
          SyncStatus.failedRemoteDelete:
        syncProcessor.addEvent(
          event: SyncEvent(
            action: SyncAction.delete,
            source: SyncSource.remote,
            localFile: localModel,
            remoteFile: null,
          ),
        );
      default:
        break;
    }
  }

  Future<void> _handleIntersection({
    required FileEntity localModel,
    required FileEntity remoteModel,
  }) async {
    switch (localModel.syncStatus) {
      case SyncStatus.deleted:
        syncProcessor.addEvent(
          event: SyncEvent(
            action: SyncAction.delete,
            source: SyncSource.local,
            localFile: localModel,
            remoteFile: remoteModel,
          ),
        );
      default:
        debugLog('for ${localModel.name}');
        debugLog('local time: ${localModel.updatedAt.toIso8601String()}');
        debugLog('remote time: ${remoteModel.updatedAt.toIso8601String()}');
        syncProcessor.addEvent(
          event: SyncEvent(
            action: SyncAction.update,
            source: localModel.updatedAt.isBefore(remoteModel.updatedAt)
                ? SyncSource.remote
                : SyncSource.local,
            localFile: localModel,
            remoteFile: remoteModel,
          ),
        );
    }
  }
}
