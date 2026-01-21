import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/data/data_source/remote/remote_data_source.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/repositories/requests/update_file_request.dart';
import 'package:cross_platform_project/domain/sync/sync_action_source/sync_action_source.dart';

class RemoteSyncActionSource extends SyncActionSource {
  final RemoteDataSource remoteDataSource;

  RemoteSyncActionSource({required this.remoteDataSource});

  @override
  Future<Result<void>> deleteFile({
    required FileModel model,
    bool softDelete = false,
  }) async {
    return await remoteDataSource.deleteFile(
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
    return await remoteDataSource.downloadFile(model: model);
  }

  @override
  Future<Result<void>> writeFile({
    required FileModel model,
    Stream<List<int>>? data,
  }) async {
    return await remoteDataSource.uploadFile(model: model, uploadData: false);
  }

  @override
  Future<Result<void>> updateFile({required FileUpdateRequest request}) async {
    final result = await remoteDataSource.updateFile(request: request);
    if (result.isFailure) {
      final fail = result as Failure;
      debugLog('${fail.message} error: ${fail.error} source: ${fail.source}');
    }
    return result;
  }
}
