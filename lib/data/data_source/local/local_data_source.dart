import 'dart:io';
import 'dart:typed_data';

import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/core/utility/safe_call.dart';
import 'package:cross_platform_project/core/utility/storage_path_service.dart';
import 'package:cross_platform_project/data/data_source/local/database/app_database.dart';
import 'package:cross_platform_project/data/data_source/local/database/dao/files_dao.dart';
import 'package:cross_platform_project/data/data_source/local/local_file_id_service.dart/local_file_id_service.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import 'package:cross_platform_project/data/services/hash_service.dart';
import '../local/local_storage_service.dart';
import '../local/json_storage.dart';

class LocalDataSource {
  final StoragePathService pathService;
  final LocalStorageService localStorage;
  final JsonStorage jsonStorage;
  final FilesDao filesTable;
  final FileModelMapper mapper;
  final HashService hashService;
  final LocalFileIdService localFileIdService;

  LocalDataSource({
    required this.pathService,
    required this.localStorage,
    required this.jsonStorage,
    required this.filesTable,
    required this.mapper,
    required this.hashService,
    required this.localFileIdService,
  });
  /* 
  Future<Result<void>> saveAsJson({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    return await safeCall(() async {
      return await jsonStorage.save(
        path: pathService.resolve(relPath: path),
        jsonData: data,
      );
    }, source: 'LocalDataSource.saveAsJson');
  }

  Future<Result<Map<String, dynamic>>> getFromJson({
    required String path,
  }) async {
    return await safeCall(() async {
      return await jsonStorage.getFromJson(
        path: pathService.resolve(relPath: path),
      );
    }, source: 'LocalDataSource.getFromJson');
  } */

  Future<Result<void>> saveFile({
    required FileModel model,
    required Uint8List? bytes,
  }) async {
    return await safeCall(() async {
      var savePath = pathService.join(
        parent: await pathService.getLocalPath(
          fileId: model.parentId,
          userId: model.ownerId,
        ),
        child: model.name,
      );
      debugLog('Saving "${model.name}" in "$savePath"');

      if (model.isFolder) {
        await localStorage.createEntity(
          path: savePath,
          isFolder: model.isFolder,
        );
      } else {
        await localStorage.saveBytes(
          path: savePath,
          bytes: bytes ?? Uint8List(0),
        );
      }
      model = model.copyWith(
        hash: await _getHash(model: model, filePath: savePath),
      );
      debugLog('after hash for ${model.name}');
      final entity = model.isFolder ? Directory(savePath) : File(savePath);
      if (!await entity.exists()) {
        debugLog('FS entity not created: $savePath');
        throw Exception('FS entity not created: $savePath');
      }
      await filesTable.insertFile(
        mapper.toInsert(
          model,
          await localFileIdService.getFileId(path: savePath),
        ),
      );
    }, source: 'LocalDataSource.saveFile');
  }

  Future<Result<Uint8List>> getFileData({required FileModel model}) async {
    return await safeCall(() async {
      return await localStorage.getBytes(
        path: await pathService.getLocalPath(
          fileId: model.id,
          userId: model.ownerId,
        ),
      );
    }, source: 'LocalDataSource.getFileData');
  }

  Future<Result<void>> saveFromDevice({
    required FileModel model,
    required String devicePath,
  }) async {
    return await safeCall(() async {
      var savePath = pathService.join(
        parent: await pathService.getLocalPath(
          fileId: model.parentId,
          userId: model.ownerId,
        ),
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
        throw Exception('FS entity not created: $savePath');
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
      var deletePath = await pathService.getLocalPath(
        fileId: model.id,
        userId: model.ownerId,
      );
      await localStorage.deleteEntity(
        path: deletePath,
        isFolder: model.isFolder,
      );
      if (!softDelete) {
        await filesTable.deleteFile(model.id);
      }
    }, source: 'LocalDataSource.deleteFile');
  }

  Future<Result<void>> updateFile({
    required FileModel model,
    bool overwrite = false,
  }) async {
    return await safeCall(() async {
      final modelPath = pathService.join(
        parent: await pathService.getLocalPath(
          fileId: model.parentId,
          userId: model.ownerId,
        ),
        child: model.name,
      );
      final currentPath = await pathService.getLocalPath(
        fileId: model.id,
        userId: model.ownerId,
      );
      if (currentPath != modelPath) {
        await localStorage.moveEntity(
          currentPath: currentPath,
          newPath: modelPath,
          isFolder: model.isFolder,
          overwrite: overwrite,
        );
      }

      model = model.copyWith(
        hash: await _getHash(model: model, filePath: modelPath),
      );
      await filesTable.updateFile(model.id, mapper.toUpdate(model));
    }, source: 'LocalDataSource.moveFile');
  }

  Future<Result<FileSystemEntity>> getFile({required FileModel model}) async {
    return await safeCall(() async {
      var getPath = await pathService.getLocalPath(
        fileId: model.id,
        userId: model.ownerId,
      );

      return localStorage.getEntity(path: getPath, isFolder: model.isFolder);
    }, source: 'LocalDataSource.getFile');
  }

  Stream<List<DbFile>> getFileStream({
    required String? parentId,
    required String ownerId,
    bool onlyFolders = false,
    bool onlyFiles = false,
  }) {
    if (onlyFolders) {
      return filesTable.watchFolders(parentId, ownerId);
    } else if (onlyFiles) {
      return filesTable.watchFiles(parentId, ownerId);
    } else {
      return filesTable.watchChildren(parentId, ownerId);
    }
  }

  Future<Result<List<DbFile>>> getFileList({required String ownerId}) async {
    return await safeCall(() async {
      return await filesTable.getFilesByOwner(ownerId);
    }, source: 'LocalDataSource.getFileList');
  }

  Future<String> _getHash({
    required FileModel model,
    required String filePath,
  }) async {
    debugLog('hash for ${model.name}');
    return model.isFolder
        ? await hashService.hashFolder(Directory(filePath))
        : await hashService.hashFile(File(filePath));
  }
}
