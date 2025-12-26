import 'package:cross_platform_project/data/providers/providers.dart';
import 'package:cross_platform_project/data/providers/storage_repository_provider.dart';
import 'package:cross_platform_project/domain/use_cases/copy_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/create_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/delete_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/get_root_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/sync_start_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/update_file_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createFileUseCaseProvider = Provider<CreateFileUseCase>((ref) {
  final repository = ref.watch(storageRepositoryProvider);
  return CreateFileUseCase(repository: repository);
});

final updateFileUseCaseProvider = Provider<UpdateFileUseCase>((ref) {
  final repository = ref.watch(storageRepositoryProvider);
  return UpdateFileUseCase(repository: repository);
});

final deleteFileUseCaseProvider = Provider<DeleteFileUseCase>((ref) {
  final repository = ref.watch(storageRepositoryProvider);
  return DeleteFileUseCase(repository: repository);
});

final syncStartUseCaseProvider = Provider<SyncStartUseCase>((ref) {
  final repository = ref.watch(storageRepositoryProvider);
  return SyncStartUseCase(repository: repository);
});

final copyFileUseCaseProvider = Provider<CopyFileUseCase>((ref) {
  final repository = ref.watch(storageRepositoryProvider);
  return CopyFileUseCase(repository: repository);
});

final getRootUseCaseProvider = Provider<GetRootUseCase>((ref) {
  final repository = ref.watch(storageRepositoryProvider);
  final auth = ref.watch(authRepositoryProvider);
  return GetRootUseCase(repository: repository, auth: auth);
});
