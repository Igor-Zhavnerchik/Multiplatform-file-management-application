import 'dart:io';
import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/core/utility/safe_call.dart';
import 'package:cross_platform_project/core/services/storage_path_service.dart';
import 'package:cross_platform_project/data/data_source/local/database/dao/files_dao.dart';
import 'package:cross_platform_project/data/data_source/local/local_file_id_service.dart/local_file_id_service.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import 'package:cross_platform_project/data/repositories/requests/update_file_request.dart';
import 'package:cross_platform_project/data/services/hash_service.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:uuid/v4.dart';
import '../local/local_storage_service.dart';

class LocalDataSource {
  final StoragePathService pathService;
  final LocalStorageService localStorage;
  final FilesDao filesTable;
  final FileModelMapper mapper;
  final HashService hashService;
  final LocalFileIdService localFileIdService;

  LocalDataSource({
    required this.pathService,
    required this.localStorage,
    required this.filesTable,
    required this.mapper,
    required this.hashService,
    required this.localFileIdService,
  });

  //FIXME get rid of waiting if possible
  Future<void> _waitFileCreation({required String path}) async {
    debugLog('waiting for creation of $path');
    for (var i = 0; i < 5; i++) {
      if (await File(path).exists() || await Directory(path).exists()) {
        return;
      }
      await Future.delayed(const Duration(milliseconds: 20));
    }
    throw Exception('file $path not created in given timeframe');
  }

  Future<Result<void>> saveFile({
    required FileModel model,
    required Stream<List<int>>? bytes,
    bool overwrite = true,
  }) async {
    return await safeCall(() async {
      var savePath = pathService.join(
        parent: await pathService.getLocalPath(fileId: model.parentId),
        child: model.name,
      );
      debugLog('Saving "${model.name}" in "$savePath"');

      if (model.isFolder) {
        await localStorage.createEntity(
          path: savePath,
          isFolder: model.isFolder,
        );
      } else if (overwrite) {
        await localStorage.saveBytes(
          path: savePath,
          bytes: bytes ?? Stream.empty(),
        );
      }

      await _waitFileCreation(path: savePath);
      model = model.copyWith(
        hash: await _getHash(model: model, filePath: savePath),
      );
      if (await filesTable.getFile(fileId: model.id) == null) {
        final localId = await localFileIdService.getFileId(path: savePath);

        debugLog('inserting ${model.name} with id:$localId');
        await filesTable.insertFile(mapper.toInsert(model, localId));
      }
    }, source: 'LocalDataSource.saveFile');
  }

  Future<Result<Stream<List<int>>>> getFileData({
    required FileModel model,
  }) async {
    return await safeCall(() async {
      return await localStorage.getBytes(
        path: await pathService.getLocalPath(fileId: model.id),
      );
    }, source: 'LocalDataSource.getFileData');
  }

  Future<Result<void>> saveFromDevice({
    required FileModel model,
    required String devicePath,
  }) async {
    return await safeCall(() async {
      var savePath = pathService.join(
        parent: await pathService.getLocalPath(fileId: model.parentId),
        child: model.name,
      );
      if (!model.isFolder) {
        var deviceFile = await localStorage.getBytes(path: devicePath);
        await localStorage.saveBytes(path: savePath, bytes: deviceFile);
      } else {
        await localStorage.createEntity(path: savePath, isFolder: true);
      }
      model = model.copyWith(
        hash: await _getHash(model: model, filePath: savePath),
      );

      final entity = model.isFolder ? Directory(savePath) : File(savePath);
      if (!await entity.exists()) {
        debugLog('FS entity not created: $savePath');
        await _waitFileCreation(path: savePath);
      }
      if (!model.isFolder) {
        model = model.copyWith(
          hash: await hashService.hashFile(file: File(savePath)),
        );
      }
      await filesTable.insertFile(
        mapper.toInsert(
          model,
          await localFileIdService.getFileId(path: savePath),
        ),
      );
    }, source: 'LocalDataSource.saveFromDevice');
  }

  Future<Result<void>> deleteFile({
    required FileModel model,
    bool softDelete = true,
  }) async {
    return await safeCall(() async {
      var deletePath = await pathService.getLocalPath(fileId: model.id);
      await localStorage.deleteEntity(
        path: deletePath,
        isFolder: model.isFolder,
      );
      if (!softDelete) {
        await filesTable.deleteFile(model.id);
      } else {
        await filesTable.updateFile(
          model.id,
          mapper.toUpdate(model.copyWith(deletedAt: DateTime.now().toUtc())),
        );
      }
    }, source: 'LocalDataSource.deleteFile');
  }

  Future<Result<void>> updateFile({
    required FileUpdateRequest request,
    bool overwrite = true,
  }) async {
    return await safeCall(() async {
      debugLog('started update');
      if ((request.parentId != null || request.name != null) && overwrite) {
        final model = await filesTable.getFile(fileId: request.id);
        if (model == null) {
          throw Exception('file to update not found id: ${request.id}');
        }
        final modelPath = pathService.join(
          parent: await pathService.getLocalPath(
            fileId: request.parentId ?? model.parentId,
          ),
          child: request.name ?? model.name,
        );
        final currentPath = await pathService.getLocalPath(fileId: model.id);

        /* debugLog('in update for ${model.name}');
      debugLog('    current path: $currentPath');
      debugLog('    model path: $modelPath'); */
        //FIXME may be optimized compare only parents if different compute path
        if (currentPath != modelPath) {
          await localStorage.moveEntity(
            currentPath: currentPath,
            newPath: modelPath,
            isFolder: model.isFolder,
            overwrite: overwrite,
          );
        }
      }
      await filesTable.updateFile(request.id, request.toCompanion());
    }, source: 'LocalDataSource.updateFile');
  }

  Future<Result<FileModel?>> getFile({
    String? fileId,
    String? localFileId,
  }) async {
    return await safeCall(() async {
      final file = await filesTable.getFile(
        fileId: fileId,
        localFileId: localFileId,
      );
      return file == null ? null : mapper.fromDbFile(file);
    }, source: 'LocalDataSource.getFile');
  }

  Stream<List<FileModel>> getFileStream({
    required String? parentId,
    required String ownerId,
    bool onlyFolders = false,
    bool onlyFiles = false,
  }) {
    debugLog('getting stream from local ');
    return filesTable
        .watchChildren(
          parentId: parentId,
          ownerId: ownerId,
          typeFilter: switch ((onlyFolders, onlyFiles)) {
            (false, false) => TypeFilter.all,
            (true, false) => TypeFilter.onlyFolders,
            (false, true) => TypeFilter.onlyFolders,
            (true, true) => throw Exception(
              'onlyFiles and onlyFolders cannot be set to true at the same time',
            ),
          },
        )
        .map(
          (fileList) =>
              fileList.map((dbFile) => mapper.fromDbFile(dbFile)).toList(),
        );
  }

  Future<Result<List<FileModel>>> getFileList({
    required String ownerId,
    bool includeDeleted = false,
  }) async {
    return await safeCall(() async {
      return (await filesTable.selectFiles(
        ownerId: ownerId,
        deleteFilter: includeDeleted
            ? DeleteFilter.include
            : DeleteFilter.exclude,
      )).map((file) => mapper.fromDbFile(file)).toList();
    }, source: 'LocalDataSource.getFileList');
  }

  Future<Result<void>> copyFile({
    required FileModel newParentModel,
    required FileModel model,
    required bool deleteOrigin,
  }) async {
    return await safeCall(() async {
      final fromPath = await pathService.getLocalPath(fileId: model.id);
      final toPath = pathService.join(
        parent: await pathService.getLocalPath(fileId: newParentModel.id),
        child: pathService.getName(fromPath),
      );
      await localStorage.copyEntity(
        fromPath: fromPath,
        toPath: toPath,
        isFolder: model.isFolder,
      );
      //FIXME indexes for same names
      /* final lastDot = model.name.lastIndexOf('.');
      final base = model.name.substring(0, lastDot);
      final ext = model.name.substring(lastDot);
      final siblings = await filesTable.getChildren(newParentModel.id, model.ownerId);
      for(var sibling in siblings){
        final number = (regex.firstMatch(model.name)?.group(1)).;
        if(number != null && number > max_same_name)
      } */
      await filesTable.insertFile(
        mapper.toInsert(
          //FIXME
          model.copyWith(
            id: UuidV4().generate(),
            parentId: newParentModel.id,
            depth: newParentModel.depth + 1,
            syncStatus: SyncStatus.created,
          ),
          await localFileIdService.getFileId(path: toPath),
        ),
      );
      if (model.isFolder) {
        final childrenList = await filesTable.getChildren(
          parentId: model.id,
          ownerId: model.ownerId,
        );
        for (var child in childrenList.map(
          (dbFile) => mapper.fromDbFile(dbFile),
        )) {
          await copyFile(
            newParentModel: model,
            model: child,
            deleteOrigin: false,
          );
        }
      }
      if (deleteOrigin) {
        await deleteFile(model: model);
      }
    }, source: 'LocalDataSource.copyFile');
  }

  Future<Result<FileModel>> getRootFolder({required String ownerId}) async {
    return safeCall(() async {
      final root = (await filesTable.getChildren(
        parentId: null,
        ownerId: ownerId,
      )).first;
      return mapper.fromDbFile(root);
    }, source: 'LocalDataSource.getrootFolder');
  }

  Future<String?> _getHash({
    required FileModel model,
    required String filePath,
  }) async {
    return model.isFolder
        ? null
        : await hashService.hashFile(file: File(filePath));
  }

  Future<FileModel?> getFileModel({required String id}) async {
    final dbFile = await filesTable.getFile(fileId: id);
    return dbFile == null ? null : mapper.fromDbFile(dbFile);
  }
}
