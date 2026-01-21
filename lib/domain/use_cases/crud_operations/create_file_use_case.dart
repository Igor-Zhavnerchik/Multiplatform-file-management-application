import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';

class CreateFileUseCase {
  final StorageRepository repository;

  CreateFileUseCase({required this.repository});

  Future<Result<void>> call({
    required FileEntity parent,
    required List<FileCreateRequest> requests,
  }) async {
    Result result = Success(null);
    for (var request in requests) {
      debugLog('processing creation request for ${request.name}');
      result = await repository.createFile(parent: parent, request: request);

      if (result is Failure) {
        break;
      }
    }

    return result;
  }
}
