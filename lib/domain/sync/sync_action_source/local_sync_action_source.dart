import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/data_source/local/local_data_source.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/repositories/requests/update_file_request.dart';
import 'package:cross_platform_project/domain/sync/sync_action_source/sync_action_source.dart';

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
  Future<Result<Stream<List<int>>?>> readFile({
    required FileModel model,
  }) async {
    if (model.isFolder) {
      return Success(null);
    }
    return await localDataSource.getFileData(model: model);
  }

  @override
  Future<Result<void>> writeFile({
    required FileModel model,
    Stream<List<int>>? data,
  }) async {
    return await localDataSource.saveFile(model: model, bytes: data);
  }

  @override
  Future<Result<void>> updateFile({required FileUpdateRequest request}) async {
    return await localDataSource.updateFile(request: request, overwrite: true);
  }
}
