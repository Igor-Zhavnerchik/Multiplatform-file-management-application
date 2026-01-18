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

  Future<String> _makeUniqueName({
    required String name,
    required String? parentId,
    required String ownerId,
  }) async {
    final int lastDot = name.lastIndexOf('.');

    final String base = lastDot != -1 ? name.substring(0, lastDot) : name;
    final String ext = lastDot != -1 ? name.substring(lastDot) : '';

    final siblings = await filesTable.getChildren(
      parentId: parentId,
      ownerId: ownerId,
    );

    // Если такого имени нет — возвращаем сразу
    final hasSame = siblings.any((e) => e.name == name);
    if (!hasSame) return name;

    final RegExp regex = RegExp(
      '^${RegExp.escape(base)} \\((\\d+)\\)${RegExp.escape(ext)}\$',
    );

    int maxIndex = 0;

    for (final sibling in siblings) {
      final match = regex.firstMatch(sibling.name);
      if (match == null) continue;

      final index = int.tryParse(match.group(1)!);
      if (index != null && index > maxIndex) {
        maxIndex = index;
      }
    }

    return '$base (${maxIndex + 1})$ext';
  }

  Future<Result<void>> saveFile({
    required FileModel model,
    required Stream<List<int>>? bytes,
    bool overwrite = true,
  }) async {
    return await safeCall(() async {
      model = model.copyWith(
        name: await _makeUniqueName(
          name: model.name,
          parentId: model.parentId,
          ownerId: model.ownerId,
        ),
      );
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
        model = model.copyWith(
          hash: await _getHash(model: model, filePath: savePath),
        );
        if (model.size == null) {
          model.copyWith(size: await File(savePath).length());
        }
      }

      if (await filesTable.getFile(fileId: model.id) == null) {
        final localId = await localFileIdService.getFileId(path: savePath);

        debugLog('inserting ${model.name} with id:$localId');
        await filesTable.insertFile(mapper.toInsert(model, localId));
      } else {
        await filesTable.updateFile(model.id, mapper.toUpdate(model));
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
      model = model.copyWith(
        name: await _makeUniqueName(
          name: model.name,
          parentId: model.parentId,
          ownerId: model.ownerId,
        ),
      );
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

      if (!model.isFolder) {
        model = model.copyWith(
          hash: await hashService.hashFile(file: File(savePath)),
          size: await File(savePath).length(),
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
      try {
        var deletePath = await pathService.getLocalPath(fileId: model.id);
        await localStorage.deleteEntity(
          path: deletePath,
          isFolder: model.isFolder,
        );
      } catch (e) {
        debugLog(e.toString());
      }

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
        debugLog('move request');
        var model = await filesTable.getFile(fileId: request.id);
        if (model == null) {
          throw Exception('file to update not found id: ${request.id}');
        }
        if (request.parentId == null || request.name == null) {
          request = request.copyWith(
            name: await _makeUniqueName(
              name: request.name ?? model.name,
              parentId: request.parentId ?? model.parentId,
              ownerId: model.ownerId,
            ),
          );
        }

        final modelPath = pathService.join(
          parent: await pathService.getLocalPath(
            fileId: request.parentId ?? model.parentId,
          ),
          child: request.name ?? model.name,
        );
        final currentPath = await pathService.getLocalPath(fileId: model.id);
        debugLog('current path: $currentPath');
        debugLog('new path: $modelPath');
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

  Future<Result<List<FileModel>>> getChildren({
    required String ownerId,
    required String parentId,
  }) async {
    return await safeCall(() async {
      return (await filesTable.getChildren(
        parentId: parentId,
        ownerId: ownerId,
      )).map((file) => mapper.fromDbFile(file)).toList();
    }, source: 'LocalDataSource.getChildren');
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
