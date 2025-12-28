import 'package:cross_platform_project/data/providers/providers.dart';
import 'package:cross_platform_project/data/providers/storage_repository_provider.dart';
import 'package:cross_platform_project/data/services/file_open_service.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/copy_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/create_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/delete_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/get_root_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/open_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/sync_start_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/update_file_use_case.dart';
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

final openFileUseCaseProvider = Provider<OpenFileUseCase>((ref) {
  final opener = ref.watch(fileOpenServiceProvider);
  return OpenFileUseCase(opener: opener);
});

final fileOpenServiceProvider = Provider<FileOpenService>((ref) {
  final pathService = ref.watch(storagePathServiceProvider);
  return FileOpenService(pathService: pathService);
});
