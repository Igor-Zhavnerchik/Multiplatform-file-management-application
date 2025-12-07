import 'package:cross_platform_project/data/providers/storage_repository_provider.dart';
import 'package:cross_platform_project/domain/use_cases/create_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/delete_file_use_case.dart';
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
