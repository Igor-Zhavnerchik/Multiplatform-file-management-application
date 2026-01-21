import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/data/data_source/local/local_data_source.dart';
import 'package:cross_platform_project/data/repositories/requests/update_file_request.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';

class SyncStatusManager {
  final LocalDataSource localDataSource;

  SyncStatusManager({required this.localDataSource});

  Future<Result<void>> updateStatus({
    required String fileId,
    required SyncStatus status,
  }) async {
    debugLog('updating status for id $fileId to "$status"');
    await localDataSource.updateFile(
      request: FileUpdateRequest(id: fileId, syncStatus: status),
    );
    return Success(null);
  }
}
