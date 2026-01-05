import 'dart:async';

import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/services/current_user_service.dart';
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
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';
import 'package:cross_platform_project/presentation/view_models/file_operations_view_model.dart';
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
    var rawFileListResult = await remoteDataSource.getFileList();
    if (rawFileListResult.isFailure) {
      return Failure('failed to fetch file list from server');
    }
    List<FileModel> fileList =
        ((rawFileListResult as Success).data as List<Map<String, dynamic>>)
            .map<FileModel>(
              (metadata) => mapper.fromMetadata(metadata: metadata),
            )
            .toList();
    return Success(fileList);
  }

  @override
  Future<Result<List<FileModel>>> getLocalFileList() async {
    print('getting file list');
    var rawFileListResult = await localDataSource.getFileList(
      ownerId: currentUserId,
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
    debugLog('emitting local create sync event');
    _controller!.add(
      SyncEvent(
        action: SyncAction.create,
        source: SyncSource.local,
        payload: newFile,
      ),
    );
    return Success(null);
  }

  @override
  Future<Result<void>> deleteFile({required FileEntity entity}) async {
    final model = mapper.fromEntity(entity);
    await syncStatusManager.updateStatus(
      fileId: model.id,
      status: SyncStatus.deletingLocally,
    );
    final deleteResult = await localDataSource.deleteFile(
      model: model.copyWith(deletedAt: DateTime.now().toUtc()),
      softDelete: true,
    );
    if (deleteResult.isFailure) {
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
    debugLog('emitting local delete sync event');
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
  Future<Result<void>> updateFile({required FileEntity entity}) async {
    var model = mapper.fromEntity(entity);
    await syncStatusManager.updateStatus(
      fileId: model.id,
      status: SyncStatus.updatingLocally,
    );
    model = model.copyWith(updatedAt: DateTime.now().toUtc());
    final updateResult = await localDataSource.updateFile(
      model: model,
    );
    if (updateResult.isFailure) {
      await syncStatusManager.updateStatus(
        fileId: model.id,
        status: SyncStatus.failedLocalUpdate,
      );
      return updateResult;
    }
    await syncStatusManager.updateStatus(
      fileId: model.id,
      status: SyncStatus.updated,
    );
    debugLog('emitting local update sync event');
    _controller!.add(
      SyncEvent(
        action: SyncAction.update,
        source: SyncSource.local,
        payload: model,
      ),
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
    debugLog('getting file stream in storage repository');
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

  @override
  Future<FileModel?> getFileModelbyId({required String id}) async {
    return await localDataSource.getFileModel(id: id);
  }
}
