import 'dart:async';

import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/services/current_user_service.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/data_source/local/local_data_source.dart';
import 'package:cross_platform_project/data/data_source/remote/remote_data_source.dart';

import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import 'package:cross_platform_project/data/repositories/requests/update_file_request.dart';
import 'package:cross_platform_project/data/services/uuid_generation_service.dart';
import 'package:cross_platform_project/domain/sync/sync_processor.dart';
import 'package:cross_platform_project/domain/sync/sync_status_manager.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageRepositoryImpl extends StorageRepository {
  final SupabaseClient client;
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final SyncStatusManager syncStatusManager;
  final FileModelMapper mapper;
  final UuidGenerationService uuidService;
  final CurrentUserService currentUserService;
  StreamController<SyncEvent>? _controller =
      StreamController<SyncEvent>.broadcast();
  @override
  Stream<SyncEvent> get localSyncEventStream => _controller!.stream;
  String get currentUserId => currentUserService.currentUserId;
  StorageRepositoryImpl({
    required this.client,
    required this.remoteDataSource,
    required this.localDataSource,
    required this.syncStatusManager,
    required this.mapper,
    required this.uuidService,
    required this.currentUserService,
  });

  void dispose() {
    debugLog('DISPOSING STORAGE REPOSITORY');
    _controller?.close();
  }

  @override
  Future<Result<List<FileModel>>> getRemoteFileList() async {
    var remoteFileListResult = await remoteDataSource.getFileList();
    return remoteFileListResult.when(
      success: (data) {
        return Success(data);
      },
      failure: (msg, err, source) {
        debugLog('$msg, error: $err source: $source');
        return Failure(msg, error: err, source: source);
      },
    );
  }

  @override
  Future<Result<List<FileModel>>> getLocalFileList() async {
    debugLog('getting file list');
    var rawFileListResult = await localDataSource.getFileList(
      ownerId: currentUserId,
      includeDeleted: true,
    );
    return rawFileListResult.when(
      success: (data) {
        return Success(data);
      },
      failure: (msg, err, source) {
        debugLog('$msg, error: $err source: $source');
        return Failure(msg, error: err, source: source);
      },
    );
  }

  @override
  Future<Result<FileEntity>> createFile({
    required FileEntity? parent,
    required FileCreateRequest request,
    bool overwrite = true,
  }) async {
    final newFileId = uuidService.generateId(
      userRoot: parent == null ? currentUserId : null,
    );
    final newFile = FileModel(
      id: newFileId,
      ownerId: parent?.ownerId ?? currentUserId,
      parentId: parent?.id,
      depth: parent?.depth ?? 0 + 1, //FIXME
      name: request.name,
      size: null,
      hash: null,
      mimeType: null,
      isFolder: request.isFolder,
      downloadEnabled: request.downloadEnabled,
      syncStatus: SyncStatus.created,
      downloadStatus: DownloadStatus.downloaded,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
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
      return Failure(
        saveResult.message,
        error: saveResult.error,
        source: saveResult.source,
      );
    }
    debugLog('emitting local create sync event');
    final createdFile =
        (await localDataSource.getFile(fileId: newFileId)) as Success;
    _controller!.add(
      SyncEvent(
        action: SyncAction.create,
        source: SyncSource.local,
        payload: createdFile.data,
      ),
    );
    return Success(mapper.toEntity(createdFile.data));
  }

  @override
  Future<Result<void>> deleteFile({required FileEntity entity}) async {
    final model = mapper.fromEntity(entity);
    await syncStatusManager.updateStatus(
      fileId: model.id,
      status: SyncStatus.deletingLocally,
    );

    if (model.isFolder) {
      final childrenResult = await localDataSource.getChildren(
        ownerId: model.ownerId,
        parentId: model.id,
      );
      final Result<void> result = await childrenResult.when(
        success: (children) async {
          for (var child in children) {
            final result = await deleteFile(entity: mapper.toEntity(child));
            if (result.isFailure) {
              return result;
            }
          }

          return Success(null);
        },
        failure: (msg, err, source) {
          debugLog('$msg error: $err  mource: $source');
          return Failure(msg, error: err, source: source);
        },
      );
      if (result.isFailure) {
        return result;
      }
    }
    final deleteResult = await localDataSource.deleteFile(
      model: model.copyWith(deletedAt: DateTime.now().toUtc()),
      softDelete: true,
    );
    if (deleteResult.isFailure) {
      final fail = deleteResult as Failure;
      debugLog('${fail.message} error: ${fail.error} source: ${fail.source}');
      await syncStatusManager.updateStatus(
        fileId: model.id,
        status: SyncStatus.failedLocalDelete,
      );
      return deleteResult;
    }
    await syncStatusManager.updateStatus(
      fileId: model.id,
      status: SyncStatus.deleted,
    );
    debugLog('emitting local delete sync event for ${model.name}');
    _controller!.add(
      SyncEvent(
        action: SyncAction.delete,
        source: SyncSource.local,
        payload: model,
      ),
    );

    return Success(null);
  }

  @override
  Future<Result<void>> updateFile({
    required FileUpdateRequest request,
    bool overwrite = true,
  }) async {
    debugLog('started updating for ${request.id}');
    debugLog('name: ${request.name}');
    final oldModel = await localDataSource.getFile(fileId: request.id);
    await syncStatusManager.updateStatus(
      fileId: request.id,
      status: SyncStatus.updatingLocally,
    );
    final updateResult = await localDataSource.updateFile(
      request: request.copyWith(updatedAt: DateTime.now().toUtc()),
      overwrite: overwrite,
    );
    if (updateResult.isFailure) {
      await syncStatusManager.updateStatus(
        fileId: request.id,
        status: SyncStatus.failedLocalUpdate,
      );
      return updateResult;
    }
    await syncStatusManager.updateStatus(
      fileId: request.id,
      status: SyncStatus.updated,
    );
    final updatedModel = await localDataSource.getFile(fileId: request.id);

    updatedModel.when(
      success: (model) {
        debugLog('AFTER UPDATE download enabled: ${model!.downloadEnabled}');

        if (request.downloadEnabled == null) {
          if (((oldModel as Success).data as FileModel).hash == model.hash) {
            debugLog('sending update event');
          } else {
            debugLog('sending load event');
          }
          _controller?.add(
            SyncEvent(
              action:
                  ((oldModel as Success).data as FileModel).hash == model.hash
                  ? SyncAction.update
                  : SyncAction.load,
              source: SyncSource.local,
              payload: model,
            ),
          );
        } else if (request.downloadEnabled!) {
          debugLog('loading after enabling download');
          _controller?.add(
            SyncEvent(
              action: SyncAction.load,
              source: SyncSource.remote,
              payload: model,
            ),
          );
        }
      },

      failure: (msg, err, source) {
        debugLog('Failed to get updated model for sync event: $msg');
      },
    );

    return Success(null);
  }

  @override
  Future<Result<void>> copyFile({
    required FileEntity newParent,
    required FileEntity entity,
    required bool isCut,
  }) async {
    debugLog('in copy for ${entity.name}');
    late final Result<void> copyResult;
    if (isCut) {
      copyResult = await updateFile(
        request: FileUpdateRequest(id: entity.id, parentId: newParent.id),
      );
    } else {
      copyResult = await createFile(
        parent: newParent,
        request: FileCreateRequest(
          name: entity.name,
          isFolder: entity.isFolder,
          downloadEnabled: entity.downloadEnabled,
          bytes: entity.isFolder
              ? null
              : (await localDataSource.getFileData(
                          model: mapper.fromEntity(entity),
                        )
                        as Success)
                    .data,
        ),
      );

      if (copyResult.isFailure) {
        return copyResult;
      } else if (entity.isFolder) {
        final childrenResult = await localDataSource.getChildren(
          ownerId: currentUserId,
          parentId: entity.id,
        );
        if (childrenResult.isFailure) {
          return childrenResult;
        }
        for (var child in (childrenResult as Success).data) {
          copyFile(
            newParent: mapper.toEntity(
              (copyResult as Success).data as FileModel,
            ),
            entity: mapper.toEntity(child as FileModel),
            isCut: false,
          );
        }
      }
    }
    return copyResult;
  }

  @override
  Future<Result<void>> createUserSaveState() async {
    var result = ensureRootExists();
    return result;
  }

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
    //required String? ownerId,
  }) {
    debugLog('getting file stream in storage repository');

    return localDataSource
        .getFileStream(
          parentId: parentId,
          ownerId: currentUserId,
          onlyFiles: onlyFiles,
          onlyFolders: onlyFolders,
        )
        .map((model) => model.map((model) => mapper.toEntity(model)).toList());
  }

  @override
  Future<FileModel?> getFileModelbyId({required String id}) async {
    return await localDataSource.getFileModel(id: id);
  }

  @override
  Future<FileModel?> getRemoteModel({required String id}) async {
    return (await remoteDataSource.getFile(fileId: id)).when(
      success: (data) => data,
      failure: (msg, err, source) {
        debugLog('$msg error: $err source: $source');
        return null;
      },
    );
  }
}
