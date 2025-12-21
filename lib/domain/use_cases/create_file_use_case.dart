import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';

class CreateFileUseCase {
  final StorageRepository repository;

  CreateFileUseCase({required this.repository});

  Future<Result<void>> call({
    required String? parentId,
    required String name,
    required int parentDepth,
    required String? fileLocalPath,
    required bool syncEnabled,
    required bool downloadEnabled,
    required isFolder,
  }) async {
    return await repository.createFile(
      parentId: parentId,
      name: name,
      parentDepth: parentDepth,
      isFolder: isFolder,
      fromPath: fileLocalPath,
      syncEnabled: syncEnabled,
      downloadEnabed: downloadEnabled,
    );
  }
}
