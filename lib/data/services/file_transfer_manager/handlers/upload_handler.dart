import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/data/data_source/remote/remote_data_source.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/services/file_transfer_manager/download_status_manager.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';

class UploadHandler {
  final RemoteDataSource remoteDataSource;
  final DownloadStatusManager statusManager;

  UploadHandler({required this.remoteDataSource, required this.statusManager});

  Future<Result<void>> handle({required FileModel model}) async {
    statusManager.setStatus(id: model.id, status: DownloadStatus.uploading);
    final uploadResult = await remoteDataSource.uploadFile(
      model: model,
      uploadData: true,
    );
    statusManager.setStatus(
      id: model.id,
      status: uploadResult.isSuccess
          ? DownloadStatus.downloaded
          : DownloadStatus.failedUpload,
    );
    return uploadResult;
  }
}
