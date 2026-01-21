import 'package:cross_platform_project/data/providers/local_data_source_providers.dart';
import 'package:cross_platform_project/data/providers/remote_data_source_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cross_platform_project/data/services/file_transfer_manager/file_transfer_manager.dart';
import 'package:cross_platform_project/data/services/file_transfer_manager/download_status_manager.dart';
import 'package:cross_platform_project/data/services/file_transfer_manager/handlers/download_handler.dart';
import 'package:cross_platform_project/data/services/file_transfer_manager/handlers/upload_handler.dart';

/// ---------------------------------------------------------------------------
/// Status manager
/// ---------------------------------------------------------------------------

final downloadStatusManagerProvider = Provider<DownloadStatusManager>((ref) {
  final localDataSource = ref.watch(localDataSourceProvider);

  return DownloadStatusManager(localDataSource: localDataSource);
});

/// ---------------------------------------------------------------------------
/// Handlers
/// ---------------------------------------------------------------------------

final downloadHandlerProvider = Provider<DownloadHandler>((ref) {
  final localDataSource = ref.watch(localDataSourceProvider);
  final remoteDataSource = ref.watch(remoteDataSourceProvider);
  final statusManager = ref.watch(downloadStatusManagerProvider);

  return DownloadHandler(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    statusManager: statusManager,
  );
});

final uploadHandlerProvider = Provider<UploadHandler>((ref) {
  final remoteDataSource = ref.watch(remoteDataSourceProvider);
  final statusManager = ref.watch(downloadStatusManagerProvider);

  return UploadHandler(
    remoteDataSource: remoteDataSource,
    statusManager: statusManager,
  );
});

/// ---------------------------------------------------------------------------
/// FileTransferManager
/// ---------------------------------------------------------------------------
final fileTransferManagerProvider = Provider<FileTransferManager>((ref) {
  final downloadHandler = ref.watch(downloadHandlerProvider);
  final uploadHandler = ref.watch(uploadHandlerProvider);

  return FileTransferManager(
    downloadHandler: downloadHandler,
    uploadHandler: uploadHandler,
  );
});
