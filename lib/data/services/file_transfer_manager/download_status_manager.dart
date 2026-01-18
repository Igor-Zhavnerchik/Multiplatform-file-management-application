import 'package:cross_platform_project/data/data_source/local/local_data_source.dart';
import 'package:cross_platform_project/data/repositories/requests/update_file_request.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';

class DownloadStatusManager {
  final LocalDataSource localDataSource;

  DownloadStatusManager({required this.localDataSource});

  Future<void> setStatus({
    required String id,
    required DownloadStatus status,
  }) async {
    await localDataSource.updateFile(
      request: FileUpdateRequest(id: id, downloadStatus: status),
    );
  }
}
