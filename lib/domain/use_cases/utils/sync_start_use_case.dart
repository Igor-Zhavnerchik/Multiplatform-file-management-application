import 'package:cross_platform_project/domain/repositories/sync_repositry.dart';

class SyncStartUseCase {
  SyncStartUseCase({required this.repository});

  final SyncRepository repository;

  Future<void> call() async {
    await repository.syncronizeAll();
  }
}
