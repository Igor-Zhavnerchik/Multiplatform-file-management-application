import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';
import 'package:cross_platform_project/presentation/widgets/file_operations_view/file_operations_view_model.dart';

class CreateFileUseCase {
  final StorageRepository repository;

  CreateFileUseCase({required this.repository});

  Future<Result<void>> call({
    required FileEntity parent,
    required List<FileCreateRequest> requests,
  }) async {
    Result result = Success(null);
    for (var request in requests) {
      result = await repository.createFile(parent: parent, request: request);

      if (result is Failure) {
        break;
      }
    }

    return result;
  }
}
