import 'dart:io';
import 'dart:typed_data';

import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/core/utility/safe_call.dart';
import 'package:cross_platform_project/core/utility/storage_path_service.dart';
import 'package:cross_platform_project/data/data_source/local/database/app_database.dart';
import 'package:cross_platform_project/data/data_source/local/database/dao/files_dao.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import '../local/local_storage_service.dart';
import '../local/json_storage.dart';

class LocalDataSource {
  final StoragePathService pathService;
  final LocalStorageService localStorage;
  final JsonStorage jsonStorage;
  final FilesDao filesTable;
  final FileModelMapper mapper;

  LocalDataSource({
    required this.pathService,
    required this.localStorage,
    required this.jsonStorage,
    required this.filesTable,
    required this.mapper,
  });

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
  }

  Future<Result<void>> saveFile({
    required FileModel model,
    required Uint8List? bytes,
  }) async {
    return await safeCall(() async {
      final path = await pathService.getLocalPath(fileId: model.id);

      if (model.isFolder) {
        await localStorage.createEntity(path: path, isFolder: model.isFolder);
      } else {
        await localStorage.saveBytes(path: path, bytes: bytes ?? Uint8List(0));
      }
      await filesTable.insertFile(mapper.toInsert(model));
    }, source: 'LocalDataSource.saveFile');
  }

  Future<Result<Uint8List>> getFileData({required FileModel model}) async {
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
      var savePath = pathService.joinFromAnotherPath(
        parent: await pathService.getLocalPath(fileId: model.parentId),
        fromPath: devicePath,
      );
      if (!model.isFolder) {
        var deviceFile = await localStorage.getBytes(path: devicePath);
        await localStorage.saveBytes(path: savePath, bytes: deviceFile);
      } else {
        await localStorage.createEntity(path: savePath, isFolder: true);
      }
      await filesTable.insertFile(mapper.toUpdate(model));
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
      }
    }, source: 'LocalDataSource.deleteFile');
  }
  /*
  Future<Result<void>> deleteFileMetadata({required FileModel model}) async {
    return await safeCall(() async {
      await filesTable.deleteFile(model.id);
    }, source: 'LocalDataSource.DeleteFileMetadata');
  }
  */

  Future<Result<void>> moveFile({
    required FileModel model,
    bool overwrite = false,
  }) async {
    return await safeCall(() async {
      await localStorage.moveEntity(
        currentPath: await pathService.getLocalPath(fileId: model.id),
        newParentPath: await pathService.getLocalPath(fileId: model.parentId),
        isFolder: model.isFolder,
        overwrite: overwrite,
      );
      await filesTable.updateFile(model.id, mapper.toUpdate(model));
    }, source: 'LocalDataSource.moveFile');
  }

  Future<Result<FileSystemEntity>> getFile({required FileModel model}) async {
    return await safeCall(() async {
      var getPath = await pathService.getLocalPath(fileId: model.id);
      return localStorage.getEntity(path: getPath, isFolder: model.isFolder);
    }, source: 'LocalDataSource.getFile');
  }

  Future<Result<void>> updateFile({required FileModel model}) async {
    return await safeCall(() async {
      await filesTable.updateFile(model.id, mapper.toUpdate(model));
    }, source: 'LocalDataSource.UpdateFile');
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
      return await filesTable.getFiles(ownerId);
    }, source: 'LocalDataSource.getFileList');
  }
}
