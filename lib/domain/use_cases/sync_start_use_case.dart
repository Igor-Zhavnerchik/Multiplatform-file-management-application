import 'package:cross_platform_project/domain/repositories/storage_repository.dart';

class SyncStartUseCase {
  SyncStartUseCase({required this.repository});

  final StorageRepository repository;

  Future<void> call() async {
    await repository.syncronize();
  }
}
