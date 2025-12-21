import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/data_source/local/database/app_database.dart';
import 'package:cross_platform_project/data/data_source/local/local_data_source.dart';
import 'package:cross_platform_project/data/data_source/remote/remote_data_source.dart';

import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import 'package:cross_platform_project/data/sync/sync_processor.dart';
import 'package:cross_platform_project/data/sync/sync_status_manager.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/repositories/auth_repository.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class StorageRepositoryImpl extends StorageRepository {
  final SupabaseClient client;
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final AuthRepository auth;
  final SyncStatusManager syncStatusManager;
  final SyncProcessor syncProcessor;
  final FileModelMapper mapper;
  late final String? currentUserId;
  StorageRepositoryImpl({
    required this.client,
    required this.remoteDataSource,
    required this.localDataSource,
    required this.auth,
    required this.syncStatusManager,
    required this.syncProcessor,
    required this.mapper,
  });

  @override
  Future<void> init() async {
    currentUserId = (await auth.getCurrentUser())!.id;
  }

  Future<Result<List<FileModel>>> _getRemoteFileList() async {
    var rawFileListResult = await remoteDataSource.getFileList();
    if (rawFileListResult.isFailure) {
      return Failure('failed to fetch file list from server');
    }
    List<FileModel> fileList =
        ((rawFileListResult as Success).data as List<Map<String, dynamic>>)
            .map<FileModel>(
              (metadata) => mapper.fromRemoteFileFodel(
                remoteFileModel: mapper.fromMetadata(metadata: metadata),
                syncEnabled: true,
                downloadEnabled: true,
                defaultStatus: SyncStatus.syncronized,
              ),
            )
            .toList();
    return Success(fileList);
  }

  Future<Result<List<FileModel>>> _getLocalFileList() async {
    print('getting file list');
    var rawFileListResult = await localDataSource.getFileList(
      ownerId: currentUserId!,
    );
    if (rawFileListResult.isFailure) {
      return Failure('failed to fetch file list from local database');
    }
    List<FileModel> fileList =
        ((rawFileListResult as Success).data as List<DbFile>)
            .map((dbFile) => mapper.fromDbFile(dbFile))
            .toList();
    return Success(fileList);
  }

  @override
  Future<Result<void>> syncronize() async {
    final remoteFileListResult = await _getRemoteFileList();
    if (remoteFileListResult.isFailure) {
      return remoteFileListResult;
    }
    final localFileListResult = await _getLocalFileList();
    if (localFileListResult.isFailure) {
      return localFileListResult;
    }

    final List<FileModel> remoteFileList =
        (remoteFileListResult as Success).data;
    final List<FileModel> localFileList = (localFileListResult as Success).data;
    print('local');
    for (var file in localFileList) {
      print(file.name);
    }
    print('remote');
    for (var file in remoteFileList) {
      print(file.name);
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
    return Success(null);
  }

  Future<void> _handleRemoteOnly({required FileModel remoteModel}) async {
    await syncStatusManager.updateStatus(
      model: remoteModel,
      status: SyncStatus.downloading,
    );
    syncProcessor.addEvent(
      action: SyncAction.load,
      source: SyncSource.remote,
      payload: remoteModel,
    );
  }

  Future<void> _handleLocalOnly({required FileModel localModel}) async {
    switch (localModel.syncStatus) {
      case SyncStatus.created || SyncStatus.failedUploadNew:
        await syncStatusManager.updateStatus(
          model: localModel,
          status: SyncStatus.uploadingNew,
        );
        syncProcessor.addEvent(
          action: SyncAction.load,
          source: SyncSource.local,
          payload: localModel,
        );
      case SyncStatus.syncronized:
        await syncStatusManager.updateStatus(
          model: localModel,
          status: SyncStatus.deletingLocally,
        );
        syncProcessor.addEvent(
          action: SyncAction.delete,
          source: SyncSource.remote,
          payload: localModel,
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
          model: localModel,
          status: SyncStatus.deletingRemotely,
        );
        syncProcessor.addEvent(
          action: SyncAction.delete,
          source: SyncSource.local,
          payload: localModel,
        );
      default:
        debugLog('for ${localModel.name}');
        debugLog('local time: ${localModel.updatedAt.toIso8601String()}');
        debugLog('remote time: ${remoteModel.updatedAt.toIso8601String()}');
        switch (localModel.updatedAt.compareTo(remoteModel.updatedAt)) {
          case > 0:
            await syncStatusManager.updateStatus(
              model: localModel,
              status: localModel.hash == remoteModel.hash
                  ? SyncStatus.updatingRemotely
                  : SyncStatus.uploading,
            );
            syncProcessor.addEvent(
              action: localModel.hash == remoteModel.hash
                  ? SyncAction.update
                  : SyncAction.load,
              source: SyncSource.local,
              payload: localModel,
            );
          case < 0:
            await syncStatusManager.updateStatus(
              model: localModel,
              status: localModel.hash == remoteModel.hash
                  ? SyncStatus.updatingLocally
                  : SyncStatus.downloading,
            );
            syncProcessor.addEvent(
              action: localModel.hash == remoteModel.hash
                  ? SyncAction.update
                  : SyncAction.load,
              source: SyncSource.remote,
              payload: remoteModel,
            );
          default:
            await syncStatusManager.updateStatus(
              model: localModel,
              status: SyncStatus.syncronized,
            );
        }
    }
  }

  String _generateUuidV4() {
    return Uuid().v4();
  }

  @override
  Future<Result<void>> createFile({
    required String? parentId,
    required String name,
    String? fromPath,
    int? size,
    required int parentDepth,
    String? mimeType,
    required bool isFolder,
    required bool syncEnabled,
    required bool downloadEnabed,
  }) async {
    final newFile = FileModel(
      id: _generateUuidV4(),
      ownerId: currentUserId!,
      parentId: parentId,
      depth: parentDepth + 1,
      name: name,
      size: size,
      hash: null,
      mimeType: mimeType,
      isFolder: isFolder,
      syncEnabled: syncEnabled,
      downloadEnabled: downloadEnabed,
      syncStatus: SyncStatus.created,
      downloadStatus: fromPath == null
          ? DownloadStatus.notDownloaded
          : DownloadStatus.downloaded,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.fromMicrosecondsSinceEpoch(0),
      deletedAt: null,
    );
    final Result<void> saveResult;
    if (fromPath != null && fromPath.isNotEmpty) {
      saveResult = await localDataSource.saveFromDevice(
        model: newFile,
        devicePath: fromPath,
      );
    } else {
      saveResult = await localDataSource.saveFile(model: newFile, bytes: null);
    }
    if (saveResult.isFailure) {
      debugLog(
        '${(saveResult as Failure).message}, error: ${saveResult.error}, source: ${saveResult.source}',
      );
      return saveResult;
    }
    return Success(null);
  }

  @override
  Future<Result<void>> deleteFile({required FileEntity entity}) async {
    final model = mapper.fromEntity(entity);
    await syncStatusManager.updateStatus(
      model: model,
      status: SyncStatus.deletingLocally,
    );
    final deleteResult = await localDataSource.deleteFile(
      model: model.copyWith(deletedAt: DateTime.now().toUtc()),
      softDelete: true,
    );
    if (deleteResult.isFailure) {
      await syncStatusManager.updateStatus(
        model: model,
        status: SyncStatus.failedLocalDelete,
      );
      return deleteResult;
    }
    await syncStatusManager.updateStatus(
      model: model,
      status: SyncStatus.deleted,
    );

    return Success(null);
  }

  @override
  Future<Result<void>> updateFile({required FileEntity entity}) async {
    final model = mapper.fromEntity(entity);
    await syncStatusManager.updateStatus(
      model: model,
      status: SyncStatus.updatingLocally,
    );
    final updateResult = await localDataSource.updateFile(model: model);
    if (updateResult.isFailure) {
      await syncStatusManager.updateStatus(
        model: model,
        status: SyncStatus.failedLocalUpdate,
      );
      return updateResult;
    }
    await syncStatusManager.updateStatus(
      model: model,
      status: SyncStatus.updated,
    );

    return Success(null);
  }

  @override
  Future<Result<void>> createUserSaveState() async {
    await syncProcessor.waitSyncCompletetion();
    final fileListResult = await _getLocalFileList();
    if (fileListResult.isFailure) {
      return Failure(
        'failed to fetch file list',
        source: 'StorageRepository.createUserSaveState',
      );
    }
    //FIXME
    if (((fileListResult as Success).data as List<FileModel>).isEmpty) {
      return await createFile(
        parentId: null,
        name: 'My Folder',
        parentDepth: -1,
        isFolder: true,
        syncEnabled: true,
        downloadEnabed: true,
      );
    }
    return Success(null);
  }

  @override
  Stream<List<FileEntity>> watchFileStream({
    required String? parentId,
    bool onlyFolders = false,
    bool onlyFiles = false,
  }) {
    return localDataSource
        .getFileStream(
          parentId: parentId,
          ownerId: currentUserId!,
          onlyFiles: onlyFiles,
          onlyFolders: onlyFolders,
        )
        .map(
          (dbList) => dbList
              .map((dbFile) => mapper.toEntity(mapper.fromDbFile(dbFile)))
              .toList(),
        );
  }
}
