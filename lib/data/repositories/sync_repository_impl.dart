import 'dart:async';

import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/data_source/remote/remote_sync_event_listener.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
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

    final List<FileModel> remoteFileList =
        (remoteFileListResult as Success).data;
    final List<FileModel> localFileList = (localFileListResult as Success).data;
    debugLog('local:');
    for (var file in localFileList) {
      debugLog('    ${file.name}');
    }
    debugLog('remote:');
    for (var file in remoteFileList) {
      debugLog('    ${file.name}');
    }

    final Map<String, FileModel> remoteMap = {};
    final Map<String, FileModel> localMap = {};
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
        case (FileModel localModel, null):
          await _handleLocalOnly(localModel: localModel);
        case (null, FileModel remoteModel):
          await _handleRemoteOnly(remoteModel: remoteModel);
        case (FileModel localModel, FileModel remoteModel):
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
            final localFile = await storage.getFileModelbyId(
              id: event.payload.id,
            );
            if (!switch (event.action) {
              SyncAction.create => localFile != null,
              SyncAction.delete => localFile == null,
              SyncAction.update =>
                (localFile == null ||
                    localFile.updatedAt.compareTo(event.payload.updatedAt) > 0),
              SyncAction.load => true,
            }) {
              syncProcessor.addEvent(event: event);
            }
          }, onError: (e) => debugLog('Error in sync stream: $e'));
    }
    if (_localStreamSubscription == null) {
      storage.localSyncEventStream.listen((event) {
        debugLog('sync repository: catched remote ${event.action} event');
        syncProcessor.addEvent(event: event);
      });
    }

    return Success(null);
  }

  Future<void> _handleRemoteOnly({required FileModel remoteModel}) async {
    /* await syncStatusManager.updateStatus(
              fileId: remoteModel.id,
      status: SyncStatus.downloading,
    ); */
    syncProcessor.addEvent(
      event: SyncEvent(
        action: SyncAction.create,
        source: SyncSource.remote,
        payload: remoteModel,
      ),
    );
  }

  Future<void> _handleLocalOnly({required FileModel localModel}) async {
    switch (localModel.syncStatus) {
      case SyncStatus.created || SyncStatus.failedUploadNew:
        await syncStatusManager.updateStatus(
          fileId: localModel.id,
          status: SyncStatus.uploadingNew,
        );
        syncProcessor.addEvent(
          event: SyncEvent(
            action: SyncAction.create,
            source: SyncSource.local,
            payload: localModel,
          ),
        );
      case SyncStatus.syncronized || SyncStatus.deleted:
        await syncStatusManager.updateStatus(
          fileId: localModel.id,
          status: SyncStatus.deletingLocally,
        );
        syncProcessor.addEvent(
          event: SyncEvent(
            action: SyncAction.delete,
            source: SyncSource.remote,
            payload: localModel,
          ),
        );
      default:
        break;
    }
  }

  Future<void> _handleIntersection({
    required FileModel localModel,
    required FileModel remoteModel,
  }) async {
    switch (localModel.syncStatus) {
      case SyncStatus.deleted:
        await syncStatusManager.updateStatus(
          fileId: localModel.id,
          status: SyncStatus.deletingRemotely,
        );
        syncProcessor.addEvent(
          event: SyncEvent(
            action: SyncAction.delete,
            source: SyncSource.local,
            payload: localModel,
          ),
        );
      default:
        /*  debugLog('for ${localModel.n)ame}');
        debugLog('local time: ${localModel.updatedAt.toIso8601String()}');
        debugLog('remote time: ${remoteModel.updatedAt.toIso8601String()}'); */
        switch (localModel.updatedAt.compareTo(remoteModel.updatedAt)) {
          case > 0:
            await syncStatusManager.updateStatus(
              fileId: localModel.id,
              status: localModel.hash == remoteModel.hash
                  ? SyncStatus.updatedLocally
                  : SyncStatus.uploading,
            );
            syncProcessor.addEvent(
              event: SyncEvent(
                action: localModel.hash == remoteModel.hash
                    ? SyncAction.update
                    : SyncAction.load,
                source: SyncSource.local,
                payload: localModel,
              ),
            );
          case < 0:
            await syncStatusManager.updateStatus(
              fileId: localModel.id,
              status: localModel.hash == remoteModel.hash
                  ? SyncStatus.updatedRemotely
                  : SyncStatus.downloading,
            );
            syncProcessor.addEvent(
              event: SyncEvent(
                action: localModel.hash == remoteModel.hash
                    ? SyncAction.update
                    : SyncAction.load,
                source: SyncSource.remote,
                payload: remoteModel,
              ),
            );
          default:
            await syncStatusManager.updateStatus(
              fileId: localModel.id,
              status: SyncStatus.syncronized,
            );
        }
    }
  }

  @override
  void addSyncEvent({required SyncEvent event}) {
    syncProcessor.addEvent(event: event);
  }
}
