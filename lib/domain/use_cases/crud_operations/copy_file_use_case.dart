import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';

class CopyFileUseCase {
  final StorageRepository repository;

  CopyFileUseCase({required this.repository});

  Future<Result<void>> call({
    required FileEntity copyFrom,
    required FileEntity copyTo,
    required bool isCut,
  }) async {
    return await repository.copyFile(
      newParent: copyTo,
      entity: copyFrom,
      isCut: isCut,
    );
  }
}
