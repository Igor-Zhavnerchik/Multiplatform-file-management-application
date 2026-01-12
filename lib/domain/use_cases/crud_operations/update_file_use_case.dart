import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/repositories/requests/update_file_request.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';

class UpdateFileUseCase {
  final StorageRepository repository;

  UpdateFileUseCase({required this.repository});

  Future<Result<void>> call({
    required FileEntity entity,
    String? newName,
    bool? downloadEnabled,
  }) async {
    return await repository.updateFile(
      request: FileUpdateRequest(
        id: entity.id,
        name: newName,
        downloadEnabled: downloadEnabled,
      ),
    );
  }
}
