import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/data_source/local/database/dao/files_dao.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';

class SyncStatusManager {
  final FilesDao filesTable;

  SyncStatusManager({required this.filesTable});

  Future<Result<void>> updateStatus({
    required String fileId,
    required SyncStatus status,
  }) async {
    debugLog('updating status for id $fileId to "$status"');
    await filesTable.updateOnlyStatus(fileId, status);
    return Success(null);
  }
}
