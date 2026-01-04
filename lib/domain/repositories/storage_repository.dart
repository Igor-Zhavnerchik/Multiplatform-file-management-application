import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/sync/sync_processor.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/presentation/view_models/file_operations_view_model.dart';

abstract class StorageRepository {
  Stream<SyncEvent> get localSyncEventStream;
  /* void init({required String userId}); */
  Future<Result<void>> createUserSaveState();
  Future<Result<void>> ensureRootExists();
  Future<Result<FileEntity>> getRootFolder();

  Future<Result<void>> createFile({
    required FileEntity? parent,
    required FileCreateRequest request,
  });

  Future<Result<void>> copyFile({
    required FileEntity newParent,
    required FileEntity entity,
    required bool deleteOrigin,
  });

  Future<FileModel?> getFileModelbyId({required String id});
  Future<Result<List<FileModel>>> getRemoteFileList();
  Future<Result<List<FileModel>>> getLocalFileList();

  Future<Result<void>> deleteFile({required FileEntity entity});
  Future<Result<void>> updateFile({required FileEntity entity});

  Stream<List<FileEntity>> watchFileStream({
    required String? parentId,
    bool onlyFolders = false,
    bool onlyFiles = false,
    required String? ownerId,
  });
}
