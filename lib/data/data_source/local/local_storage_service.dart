import 'dart:io';
import 'dart:typed_data';

import 'package:cross_platform_project/core/utility/storage_path_service.dart';

class LocalStorageService {
  final StoragePathService pathService;

  LocalStorageService({required this.pathService});

  FileSystemEntity getEntity({required String path, required bool isFolder}) {
    FileSystemEntity entity = isFolder ? Directory(path) : File(path);
    return entity;
  }

  Future<void> saveBytes({
    required String path,
    required Uint8List bytes,
  }) async {
    var file = getEntity(path: path, isFolder: false) as File;
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    await file.writeAsBytes(bytes);
  }

  Future<Uint8List> getBytes({required String path}) async {
    var file = getEntity(path: path, isFolder: false) as File;
    if (await file.exists()) {
      return await file.readAsBytes();
    } else {
      throw Exception('file not exists path: $path');
    }
  }

  Future<void> moveEntity({
    required String currentPath,
    required String newParentPath,
    required bool isFolder,
    bool overwrite = false,
  }) async {
    var entity = getEntity(path: currentPath, isFolder: isFolder);
    var parentDir =
        getEntity(path: newParentPath, isFolder: false) as Directory;
    if (!await parentDir.exists()) {
      await parentDir.create(recursive: true);
    }
    if (overwrite && await entity.exists()) {
      await deleteEntity(path: newParentPath, isFolder: isFolder);
    }
    await entity.rename(newParentPath);
  }

  Future<void> deleteEntity({
    required String path,
    required bool isFolder,
  }) async {
    FileSystemEntity entity = getEntity(path: path, isFolder: isFolder);
    if (await entity.exists()) {
      await entity.delete(recursive: isFolder);
    }
  }

  Future<void> createEntity({
    required String path,
    required bool isFolder,
  }) async {
    FileSystemEntity entity = getEntity(path: path, isFolder: isFolder);
    if (!await entity.exists()) {
      isFolder
          ? (entity as Directory).create(recursive: true)
          : (entity as File).create();
    } else {
      print(path);
      throw Exception('File already exists path: $path');
    }
  }
}
