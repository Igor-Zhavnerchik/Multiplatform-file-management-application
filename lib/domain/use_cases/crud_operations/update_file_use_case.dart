import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/data/repositories/requests/update_file_request.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';

class UpdateFileUseCase {
  final StorageRepository repository;

  UpdateFileUseCase({required this.repository});

  Future<Result<void>> call({
    required FileEntity entity,
    String? newName,
    bool? contentSyncEnabled,
  }) async {
    Result<void> result = Failure(
      'no parameters to update',
      source: 'UpdateFileUseCase',
    );
    if (newName != null) {
      result = await repository.updateFile(
        request: FileUpdateRequest(id: entity.id, name: newName),
      );
    }

    if (contentSyncEnabled != null) {
      await _updateContentSyncEnabled(
        entity: entity,
        isEnabled: contentSyncEnabled,
      );
    }

    return result;
  }

  Future<Result<void>> _updateContentSyncEnabled({
    required FileEntity entity,
    required bool isEnabled,
  }) async {
    Result<void> result = await repository.updateFile(
      request: FileUpdateRequest(id: entity.id, contentSyncEnabled: isEnabled),
    );
    if (entity.isFolder) {
      for (FileEntity child
          in (await repository.getChildren(id: entity.id) as Success).data) {
        result = await _updateContentSyncEnabled(
          entity: child,
          isEnabled: isEnabled,
        );
      }
    }
    return result;
  }
}
