import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';

abstract class StorageRepository {
  Future<void> init();

  Future<void> syncronize();
  Future<Result<void>> createUserSaveState();

  Future<Result<void>> createFile({
    required String? parentId,
    required String name,
    String? fromPath,
    int? size,
    required bool isFolder,
    required bool syncEnabled,
    required bool downloadEnabed,
  });

  Future<Result<void>> deleteFile({required FileEntity entity});
  Future<Result<void>> updateFile({required FileEntity entity});

  Stream<List<FileEntity>> watchFileStream({
    required String? parentId,
    bool onlyFolders = false,
    bool onlyFiles = false,
  });
}
