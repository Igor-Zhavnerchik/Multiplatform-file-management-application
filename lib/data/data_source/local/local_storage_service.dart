import 'dart:io';

import 'package:cross_platform_project/core/services/storage_path_service.dart';

class LocalStorageService {
  final StoragePathService pathService;

  LocalStorageService({required this.pathService});

  FileSystemEntity getEntity({required String path, required bool isFolder}) {
    FileSystemEntity entity = isFolder ? Directory(path) : File(path);
    return entity;
  }

  Future<void> saveBytes({
    required String path,
    required Stream<List<int>> bytes,
  }) async {
    var file = getEntity(path: path, isFolder: false) as File;
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    await file.openWrite(mode: FileMode.write).addStream(bytes);
  }

  Future<Stream<List<int>>> getBytes({required String path}) async {
    var file = getEntity(path: path, isFolder: false) as File;
    if (await file.exists()) {
      return file.openRead();
    } else {
      throw Exception('file not exists path: $path');
    }
  }

  Future<void> moveEntity({
    required String currentPath,
    required String newPath,
    required bool isFolder,
    bool overwrite = false,
  }) async {
    /* 
    print('current: $currentPath');
    print('new: $newPath'); */
    final entity = getEntity(path: currentPath, isFolder: isFolder);
    final newEntity = getEntity(path: newPath, isFolder: isFolder);
    var parentDir = newEntity
        .parent; //getEntity(path: newParentPath, isFolder: true) as Directory;
    if (!await parentDir.exists()) {
      await parentDir.create(recursive: true);
    }
    if (overwrite && await entity.exists()) {
      await deleteEntity(path: newPath, isFolder: isFolder);
    }
    await entity.rename(newPath);
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
    isFolder
        ? (entity as Directory).create(recursive: true)
        : (entity as File).create();
  }

  Future<void> copyEntity({
    required String fromPath,
    required String toPath,
    required bool isFolder,
  }) async {
    if (isFolder) {
      final dir = Directory(toPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
    } else {
      final file = File(fromPath);
      await file.copy(toPath);
    }
  }
}
