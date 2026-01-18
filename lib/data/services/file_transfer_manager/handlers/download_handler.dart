import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/data_source/local/local_data_source.dart';
import 'package:cross_platform_project/data/data_source/remote/remote_data_source.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/services/file_transfer_manager/download_status_manager.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';

class DownloadHandler {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;
  final DownloadStatusManager statusManager;

  DownloadHandler({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.statusManager,
  });

  Future<Result<void>> handle({required FileModel model}) async {
    statusManager.setStatus(id: model.id, status: DownloadStatus.downloading);
    final dataResult = await remoteDataSource.downloadFile(model: model);
    return dataResult.when(
      success: (data) async {
        final downloadResult = await localDataSource.saveFile(
          model: model,
          bytes: data,
        );
        statusManager.setStatus(
          id: model.id,
          status: downloadResult.isSuccess
              ? DownloadStatus.downloaded
              : DownloadStatus.failedDownload,
        );
        return downloadResult;
      },
      failure: (_, _, _) {
        statusManager.setStatus(
          id: model.id,
          status: DownloadStatus.failedDownload,
        );
        return dataResult;
      },
    );
  }
}
