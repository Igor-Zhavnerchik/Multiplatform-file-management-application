import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';

class DeleteFileUseCase {
  final StorageRepository repository;

  DeleteFileUseCase({required this.repository});

  Future<Result<void>> call({required FileEntity entity}) async {
    return await repository.deleteFile(entity: entity);
  }
}
