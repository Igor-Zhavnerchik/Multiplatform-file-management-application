import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/data/repositories/requests/create_file_request.dart';
import 'package:cross_platform_project/data/repositories/requests/update_file_request.dart';
import 'package:cross_platform_project/domain/sync/sync_processor.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';

abstract class StorageRepository {
  Stream<SyncEvent> get localSyncEventStream;
  Future<Result<void>> createUserSaveState();
  Future<Result<void>> ensureRootExists();

  Future<Result<void>> copyFile({
    required FileEntity newParent,
    required FileEntity entity,
    required bool isCut,
  });

  Future<FileEntity?> getFileEntitybyId({required String id});
  Future<FileEntity?> getRemoteEntity({required String id});
  Future<Result<List<FileEntity>>> getRemoteFileList();
  Future<Result<List<FileEntity>>> getLocalFileList();
  Future<Result<List<FileEntity>>> getChildren({required String id});

  Future<Result<FileEntity>> createFile({
    required FileEntity? parent,
    required FileCreateRequest request,
    bool overwrite,
  });

  Future<Result<void>> deleteFile({
    required FileEntity entity,
    required bool localDelete,
  });

  Future<Result<void>> updateFile({
    required FileUpdateRequest request,
    bool overwrite,
  });

  Stream<List<FileEntity>> watchFileStream({
    required String? parentId,
    bool onlyFolders = false,
    bool onlyFiles = false,
  });
}
