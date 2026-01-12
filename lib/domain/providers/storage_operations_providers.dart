import 'package:cross_platform_project/data/repositories/providers/storage_repository_provider.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/copy_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/create_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/delete_file_use_case.dart';
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

final copyFileUseCaseProvider = Provider<CopyFileUseCase>((ref) {
  final repository = ref.watch(storageRepositoryProvider);
  return CopyFileUseCase(repository: repository);
});
