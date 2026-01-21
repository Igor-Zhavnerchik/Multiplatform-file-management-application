import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/repositories/requests/update_file_request.dart';

abstract class SyncActionSource {
  Future<Result<void>> updateFile({required FileUpdateRequest request});
  Future<Result<Stream<List<int>>?>> readFile({required FileModel model});
  Future<Result<void>> writeFile({
    required FileModel model,
    Stream<List<int>>? data,
  });
  Future<Result<void>> deleteFile({
    required FileModel model,
    bool softDelete = true,
  });
}
