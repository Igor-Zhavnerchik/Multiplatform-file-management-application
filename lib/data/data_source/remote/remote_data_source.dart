import 'dart:io';

import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/application/services/current_user_service.dart';
import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/common/utility/safe_call.dart';
import 'package:cross_platform_project/data/services/storage_path_service.dart';
import 'package:cross_platform_project/data/data_source/remote/remote_database_data_source.dart';
import 'package:cross_platform_project/data/data_source/remote/remote_storage_data_source.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import 'package:cross_platform_project/data/repositories/requests/update_file_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteDataSource {
  final RemoteStorageDataSource storage;
  final RemoteDatabaseDataSource database;
  final SupabaseClient client;
  final CurrentUserService userService;
  final StoragePathService pathService;
  final FileModelMapper mapper;
  String get currentUserId => userService.currentUserId;

  RemoteDataSource({
    required this.client,
    required this.userService,
    required this.storage,
    required this.database,
    required this.pathService,
    required this.mapper,
  });

  Future<Result<List<FileModel>>> getFileList() async {
    return await safeCall(() async {
      debugLog('getting files from supabase for user id: $currentUserId');
      final rawData = await database.getMetadata(userId: currentUserId);
      return rawData
          .map<FileModel>((metadata) => mapper.fromMetadata(metadata: metadata))
          .toList();
    }, source: 'RemoteDataSource.getFileList');
  }

  Future<Result<FileModel?>> getFile({required String fileId}) async {
    return await safeCall(() async {
      final file = await database.getSingleMetadata(
        userId: currentUserId,
        fileId: fileId,
      );
      return file == null ? null : mapper.fromMetadata(metadata: file);
    }, source: 'RemoteDataSource.getFile');
  }

  Future<Result<Stream<List<int>>>> downloadFile({
    required FileModel model,
  }) async {
    return await safeCall(() async {
      return await storage.downloadFile(
        path: pathService.getRemotePath(fileId: model.id),
      );
    }, source: 'RemoteDataSource');
  }

  Future<Result<void>> uploadFile({
    required FileModel model,
    required bool uploadData,
  }) async {
    return await safeCall(() async {
      if (!model.isFolder && uploadData) {
        await storage.uploadFile(
          file: File(await pathService.getLocalPath(fileId: model.id)),
          path: pathService.getRemotePath(fileId: model.id),
        );
      }
      await database.uploadMetadata(metadata: mapper.toMetadata(model: model));
    }, source: 'RemoteDataSource.uploadFile');
  }

  Future<Result<void>> updateFile({required FileUpdateRequest request}) async {
    return await safeCall(() async {
      await database.uploadMetadata(metadata: request.toMetadata());
    }, source: 'RemoteDataSource.updateFile');
  }

  Future<Result<void>> deleteFile({
    required FileModel model,
    bool softDelete = false,
  }) async {
    return await safeCall(() async {
      if (!softDelete) {
        if (!model.isFolder) {
          await storage.deleteFile(
            path: pathService.getRemotePath(fileId: model.id),
          );
        }
        await database.deleteMetadata(id: model.id);
      }
    }, source: 'RemoteDataSource.deleteFile');
  }
}
