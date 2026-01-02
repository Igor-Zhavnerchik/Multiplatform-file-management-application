import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/data_source/local/database/app_database.dart';
import 'package:cross_platform_project/data/data_source/local/local_data_source.dart';
import 'package:cross_platform_project/data/data_source/remote/remote_data_source.dart';

import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import 'package:cross_platform_project/data/services/uuid_generation_service.dart';
import 'package:cross_platform_project/data/sync/sync_processor.dart';
import 'package:cross_platform_project/data/sync/sync_status_manager.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/repositories/auth_repository.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';
import 'package:cross_platform_project/presentation/widgets/file_operations_view/file_operations_view_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageRepositoryImpl extends StorageRepository {
  final SupabaseClient client;
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final AuthRepository auth;
  final SyncStatusManager syncStatusManager;
  final SyncProcessor syncProcessor;
  final FileModelMapper mapper;
  final UuidGenerationService uuidService;
  late final String currentUserId;
  StorageRepositoryImpl({
    required this.client,
    required this.remoteDataSource,
    required this.localDataSource,
    required this.auth,
    required this.syncStatusManager,
    required this.syncProcessor,
    required this.mapper,
    required this.uuidService,
  });

  @override
  void init({required String userId}) {
    currentUserId = userId;
    debugLog('storage repository initialized with user id: $userId');
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
      case SyncStatus.syncronized || SyncStatus.deleted:
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
        /*  debugLog('for ${localModel.name}');
        debugLog('local time: ${localModel.updatedAt.toIso8601String()}');
        debugLog('remote time: ${remoteModel.updatedAt.toIso8601String()}'); */
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

  @override
  Future<Result<void>> createFile({
    required FileEntity? parent,
    required FileCreateRequest request,
    bool overwrite = true,
  }) async {
    final newFile = FileModel(
      id: uuidService.generateId(
        userRoot: parent == null ? currentUserId : null,
      ),
      ownerId: parent?.ownerId ?? currentUserId,
      parentId: parent?.id,
      depth: parent?.depth ?? 0 + 1,
      name: request.name,
      size: null, //FIXME
      hash: null,
      mimeType: null,
      isFolder: request.isFolder,
      syncEnabled: request.syncEnabled,
      downloadEnabled: request.downloadEnabled,
      syncStatus: SyncStatus.created,
      downloadStatus: request.localPath != null || request.bytes != null
          ? DownloadStatus.downloaded
          : DownloadStatus.notDownloaded,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.fromMicrosecondsSinceEpoch(0),
      deletedAt: null,
    );
    final Result<void> saveResult;
    if (request.localPath != null) {
      saveResult = await localDataSource.saveFromDevice(
        model: newFile,
        devicePath: request.localPath!,
      );
    } else {
      saveResult = await localDataSource.saveFile(
        overwrite: overwrite,
        model: newFile,
        bytes: request.bytes,
      );
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
    var model = mapper.fromEntity(entity);
    await syncStatusManager.updateStatus(
      model: model,
      status: SyncStatus.updatingLocally,
    );
    model = model.copyWith(updatedAt: DateTime.now().toUtc());
    final updateResult = await localDataSource.updateFile(
      model: model.copyWith(updatedAt: DateTime.now().toUtc()),
    );
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
  Future<Result<void>> copyFile({
    required FileEntity newParent,
    required FileEntity entity,
    required bool deleteOrigin,
  }) async {
    final newParentModel = mapper.fromEntity(newParent);
    final model = mapper.fromEntity(entity);
    final result = await localDataSource.copyFile(
      model: model,
      newParentModel: newParentModel,
      deleteOrigin: deleteOrigin,
    );
    if (result.isFailure) {
      return Failure('Failed to copy to ${newParent.name} from ${entity.name}');
    } else {
      return Success(null);
    }
  }

  @override
  Future<Result<void>> createUserSaveState() async {
    var result = ensureRootExists();
    return result;
  }

  @override
  Future<Result<FileEntity>> getRootFolder() async {
    final result = await localDataSource.getRootFolder(ownerId: currentUserId);
    if (result.isFailure) {
      return Failure(
        (result as Failure).message,
        source: (result as Failure).source,
      );
    } else {
      return Success(mapper.toEntity((result as Success).data));
    }
  }

  @override
  Future<Result<void>> ensureRootExists() async {
    debugLog('ensuring root exists for user $currentUserId');
    var result = await getRootFolder();
    if (result.isFailure) {
      debugLog('root not exists. creating root');
      return await createFile(
        parent: null,
        request: FileCreateRequest(
          name: 'Storage',
          isFolder: true,
          downloadEnabled: true,
          syncEnabled: true,
        ),
      );
    }
    return Success(null);
  }

  @override
  Stream<List<FileEntity>> watchFileStream({
    required String? parentId,
    bool onlyFolders = false,
    bool onlyFiles = false,
    required String? ownerId,
  }) {
    return ownerId != null
        ? localDataSource
              .getFileStream(
                parentId: parentId,
                ownerId: ownerId,
                onlyFiles: onlyFiles,
                onlyFolders: onlyFolders,
              )
              .map(
                (dbList) => dbList
                    .map((dbFile) => mapper.toEntity(mapper.fromDbFile(dbFile)))
                    .toList(),
              )
        : Stream.empty();
  }
}
