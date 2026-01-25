import 'dart:async';

import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/application/services/current_user_service.dart';
import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/data/data_source/local/local_data_source.dart';
import 'package:cross_platform_project/data/data_source/remote/remote_data_source.dart';

import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import 'package:cross_platform_project/data/repositories/requests/create_file_request.dart';
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
  Future<Result<List<FileEntity>>> getRemoteFileList() async {
    var remoteFileListResult = await remoteDataSource.getFileList();
    return remoteFileListResult.when(
      success: (data) {
        return Success(
          data.map((element) => mapper.toEntity(element)).toList(),
        );
      },
      failure: (msg, err, source) {
        debugLog('$msg, error: $err source: $source');
        return Failure(msg, error: err, source: source);
      },
    );
  }

  @override
  Future<Result<List<FileEntity>>> getLocalFileList() async {
    debugLog('getting file list');
    var rawFileListResult = await localDataSource.getFileList(
      ownerId: currentUserId,
      includeDeleted: true,
    );
    return rawFileListResult.when(
      success: (data) {
        return Success(
          data.map((element) => mapper.toEntity(element)).toList(),
        );
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
    final now = DateTime.now().toUtc();
    final newFile = FileModel(
      id: newFileId,
      ownerId: parent?.ownerId ?? currentUserId,
      parentId: parent?.id,
      name: request.name,
      size: null,
      hash: null,
      isFolder: request.isFolder,
      contentSyncEnabled: request.contentSyncEnabled,
      syncStatus: SyncStatus.created,
      downloadStatus: DownloadStatus.downloaded,
      createdAt: now,
      updatedAt: now,
      contentUpdatedAt: now,
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
        bytes: request.bytes ?? Stream.empty(),
      );
    }
    return await saveResult.when(
      success: (_) async {
        debugLog('emitting local create sync event');
        final Result<FileModel?> result = await localDataSource.getFile(
          fileId: newFileId,
        );
        return result.when(
          success: (created) {
            if (created != null) {
              final entity = mapper.toEntity(created);
              _controller!.add(
                SyncEvent(
                  action: SyncAction.create,
                  source: SyncSource.local,
                  localFile: mapper.toEntity(created),
                  remoteFile: null,
                ),
              );
              return Success(entity);
            } else {
              return Failure(
                'no file was created',
                source: 'StorageRepository.createFile',
              );
            }
          },
          failure: (msg, err, source) {
            return Failure(msg, error: err, source: source);
          },
        );
      },
      failure: (msg, err, source) {
        debugLog('$msg, error: $err, source: $source');
        return Failure(msg, error: err, source: source);
      },
    );
  }

  @override
  Future<Result<void>> deleteFile({
    required FileEntity entity,
    required bool localDelete,
  }) async {
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
            final result = await deleteFile(
              entity: mapper.toEntity(child),
              localDelete: localDelete,
            );
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
      model: model,
      softDelete: true,
      localDelete: localDelete,
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
      status: localDelete ? SyncStatus.syncronized : SyncStatus.deleted,
    );
    debugLog('emitting local delete sync event for ${model.name}');
    if (!localDelete) {
      _controller!.add(
        SyncEvent(
          action: SyncAction.delete,
          source: SyncSource.local,
          localFile: mapper.toEntity(model),
          remoteFile: null,
        ),
      );
    }

    return Success(null);
  }

  @override
  Future<Result<void>> updateFile({
    required FileUpdateRequest request,
    bool overwrite = true,
  }) async {
    debugLog('started updating for ${request.id}');
    debugLog('name: ${request.name}');
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
      status: SyncStatus.syncronized,
    );
    final updatedModel = await localDataSource.getFile(fileId: request.id);

    updatedModel.when(
      success: (model) {
        debugLog('AFTER UPDATE sync enabled: ${model!.contentSyncEnabled}');
        _controller?.add(
          SyncEvent(
            action: SyncAction.update,
            source: SyncSource.local,
            localFile: mapper.toEntity(model),
            remoteFile: null,
          ),
        );
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
          contentSyncEnabled: entity.contentSyncEnabled,
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
          contentSyncEnabled: true,
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
  Future<FileEntity?> getFileEntitybyId({required String id}) async {
    final model = await localDataSource.getFileModel(id: id);
    return model == null ? null : mapper.toEntity(model);
  }

  @override
  Future<FileEntity?> getRemoteEntity({required String id}) async {
    return (await remoteDataSource.getFile(fileId: id)).when(
      success: (data) => data == null ? null : mapper.toEntity(data),
      failure: (msg, err, source) {
        debugLog('$msg error: $err source: $source');
        return null;
      },
    );
  }

  @override
  Future<Result<List<FileEntity>>> getChildren({required String id}) async {
    return (await localDataSource.getChildren(
      ownerId: currentUserId,
      parentId: id,
    )).when(
      success: (data) =>
          Success(data.map((model) => mapper.toEntity(model)).toList()),
      failure: (msg, err, source) {
        debugLog('$msg error: $err source: $source');
        return Failure(msg, error: err, source: source);
      },
    );
  }
}
