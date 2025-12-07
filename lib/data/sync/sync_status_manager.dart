import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/data_source/local/local_data_source.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';

class SyncStatusManager {
  final LocalDataSource localSource;

  SyncStatusManager({required this.localSource});

  Future<Result<void>> updateStatus({
    required FileModel model,
    required SyncStatus status,
  }) async {
    return await localSource.updateFile(
      model: model.copyWith(syncStatus: status),
    );
  }
}
