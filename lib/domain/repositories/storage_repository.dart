import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/repositories/requests/update_file_request.dart';
import 'package:cross_platform_project/domain/sync/sync_processor.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';

class FileCreateRequest {
  final String? localPath;
  final Stream<List<int>>? bytes;
  final String name;
  final bool isFolder;
  final bool contentSyncEnabled;

  FileCreateRequest({
    required this.name,
    this.localPath,
    this.bytes,
    required this.isFolder,
    required this.contentSyncEnabled,
  });

  FileCreateRequest copyWith({
    String? localPath,
    Stream<List<int>>? bytes,
    String? name,
    bool? isFolder,
    bool? contentSyncEnabled,
  }) {
    return FileCreateRequest(
      name: name ?? this.name,
      localPath: localPath ?? this.localPath,
      bytes: bytes ?? this.bytes,
      isFolder: isFolder ?? this.isFolder,
      contentSyncEnabled: contentSyncEnabled ?? this.contentSyncEnabled,
    );
  }
}

abstract class StorageRepository {
  Stream<SyncEvent> get localSyncEventStream;
  Future<Result<void>> createUserSaveState();
  Future<Result<void>> ensureRootExists();

  Future<Result<FileEntity>> createFile({
    required FileEntity? parent,
    required FileCreateRequest request,
    bool overwrite,
  });

  Future<Result<void>> copyFile({
    required FileEntity newParent,
    required FileEntity entity,
    required bool isCut,
  });

  Future<FileModel?> getFileModelbyId({required String id});
  Future<FileModel?> getRemoteModel({required String id});
  Future<Result<List<FileModel>>> getRemoteFileList();
  Future<Result<List<FileModel>>> getLocalFileList();

  Future<Result<void>> deleteFile({required FileEntity entity});
  Future<Result<void>> updateFile({
    required FileUpdateRequest request,
    bool overwrite,
  });

  Stream<List<FileEntity>> watchFileStream({
    required String? parentId,
    bool onlyFolders = false,
    bool onlyFiles = false,
    //required String? ownerId,
  });
}
