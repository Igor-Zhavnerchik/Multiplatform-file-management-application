import 'dart:typed_data';

import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/data_source/local/local_data_source.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/sync/sync_action_source/sync_action_source.dart';

class LocalSyncActionSource extends SyncActionSource {
  final LocalDataSource localDataSource;

  LocalSyncActionSource({required this.localDataSource});

  @override
  Future<Result<void>> deleteFile({
    required FileModel model,
    bool softDelete = true,
  }) async {
    return await localDataSource.deleteFile(
      model: model,
      softDelete: softDelete,
    );
  }

  @override
  Future<Result<Uint8List?>> readFile({required FileModel model}) async {
    if (model.isFolder) {
      return Success(null);
    }
    return await localDataSource.getFileData(model: model);
  }

  @override
  Future<Result<void>> writeFile({
    required FileModel model,
    Uint8List? data,
  }) async {
    return await localDataSource.saveFile(model: model, bytes: data);
  }

  @override
  Future<Result<void>> updateFile({required FileModel model}) async {
    return await localDataSource.moveFile(model: model, overwrite: true);
  }
}
