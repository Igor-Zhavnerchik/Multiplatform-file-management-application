import 'package:cross_platform_project/core/providers/file_picker_service_provider.dart';
import 'package:cross_platform_project/core/providers/settings_service_provider.dart';
import 'package:cross_platform_project/data/providers/providers.dart';
import 'package:cross_platform_project/data/providers/storage_repository_provider.dart';
import 'package:cross_platform_project/core/services/file_open_service.dart';
import 'package:cross_platform_project/domain/providers/sync_repository_provider.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/copy_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/create_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/delete_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/rename_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/get_root_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/open_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/pick_existing_files_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/sync_start_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createFileUseCaseProvider = Provider<CreateFileUseCase>((ref) {
  final repository = ref.watch(storageRepositoryProvider);
  return CreateFileUseCase(repository: repository);
});

final renameFileUseCaseProvider = Provider<RenameFileUseCase>((ref) {
  final repository = ref.watch(storageRepositoryProvider);
  return RenameFileUseCase(repository: repository);
});

final deleteFileUseCaseProvider = Provider<DeleteFileUseCase>((ref) {
  final repository = ref.watch(storageRepositoryProvider);
  return DeleteFileUseCase(repository: repository);
});

final syncStartUseCaseProvider = Provider<SyncStartUseCase>((ref) {
  final repository = ref.watch(syncRepositoryProvider);
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

final pickExistingFilesUseCaseProvider = Provider<PickExistingFilesUseCase>((
  ref,
) {
  final filePickerService = ref.watch(filePickerServiceProvider);
  final settingsService = ref.watch(settingsServiceProvider);
  final storage = ref.watch(storageRepositoryProvider);
  return PickExistingFilesUseCase(
    storage: storage,
    filePickerService: filePickerService,
    settingsService: settingsService,
  );
});
