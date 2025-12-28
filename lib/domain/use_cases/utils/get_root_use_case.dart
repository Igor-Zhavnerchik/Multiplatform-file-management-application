import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/repositories/auth_repository.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';

class GetRootUseCase {
  final StorageRepository repository;
  final AuthRepository auth;

  GetRootUseCase({required this.repository, required this.auth});
  @deprecated
  Future<Result<FileEntity>> call() async {
    return await repository.getRootFolder(ownerId: (await auth.getCurrentUser())!.id);
  }
}
