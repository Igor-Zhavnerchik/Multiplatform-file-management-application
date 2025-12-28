import 'dart:io';
import 'dart:typed_data';

import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/core/utility/safe_call.dart';
import 'package:cross_platform_project/core/services/storage_path_service.dart';
import 'package:cross_platform_project/data/data_source/remote/remote_database_data_source.dart';
import 'package:cross_platform_project/data/data_source/remote/remote_storage_data_source.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import 'package:cross_platform_project/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteDataSource {
  final RemoteStorageDataSource storage;
  final RemoteDatabaseDataSource database;
  final SupabaseClient client;
  final AuthRepository auth;
  final StoragePathService pathService;
  final FileModelMapper mapper;

  RemoteDataSource({
    required this.client,
    required this.auth,
    required this.storage,
    required this.database,
    required this.pathService,
    required this.mapper,
  });

  Future<Result<List<Map<String, dynamic>>>> getFileList({
    bool getDeleted = false,
  }) async {
    return await safeCall(() async {
      return await database.getMetadata(
        getDeleted: getDeleted,
        userId: (await auth.getCurrentUser())!.id,
      );
    }, source: 'RemoteDataSource.getFileList');
  }

  Future<Result<Uint8List>> downloadFile({required FileModel model}) async {
    return await safeCall(() async {
      return await storage.downloadFile(
        path: pathService.getRemotePath(
          userId: model.ownerId,
          fileId: model.id,
        ),
      );
    }, source: 'RemoteDataSource');
  }

  Future<Result<void>> uploadFile({required FileModel model}) async {
    return await safeCall(() async {
      if (!model.isFolder) {
        await storage.uploadFile(
          file: File(await pathService.getLocalPath(fileId: model.id)),
          path: pathService.getRemotePath(
            userId: model.ownerId,
            fileId: model.id,
          ),
        );
      }
      await database.uploadMetadata(metadata: mapper.toMetadata(model: model));
    }, source: 'RemoteDataSource.uploadFile');
  }

  Future<Result<void>> updateFile({required FileModel model}) async {
    return await safeCall(() async {
      await database.uploadMetadata(metadata: mapper.toMetadata(model: model));
    }, source: 'RemoteDataSource.updateFile');
  }

  Future<Result<void>> deleteFile({
    required FileModel model,
    bool softDelete = true,
  }) async {
    return await safeCall(() async {
      if (softDelete) {
        await database.uploadMetadata(
          metadata: mapper.toMetadata(
            model: model.copyWith(deletedAt: DateTime.now()),
          ),
        );
      } else {
        if (!model.isFolder) {
          await storage.deleteFile(
            path: pathService.getRemotePath(
              userId: model.ownerId,
              fileId: model.id,
            ),
          );
        }
        await database.deleteMetadata(id: model.id);
      }
    }, source: 'RemoteDataSource.deleteFile');
  }
}
