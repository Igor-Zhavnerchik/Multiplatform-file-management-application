import 'package:cross_platform_project/core/providers/file_open_service_provider.dart';
import 'package:cross_platform_project/core/providers/file_picker_service_provider.dart';
import 'package:cross_platform_project/core/providers/settings_service_provider.dart';
import 'package:cross_platform_project/data/repositories/providers/storage_repository_provider.dart';
import 'package:cross_platform_project/domain/providers/sync_repository_provider.dart';
import 'package:cross_platform_project/domain/use_cases/utils/open_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/pick_existing_files_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/set_settings_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/sync_start_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final openFileUseCaseProvider = Provider<OpenFileUseCase>((ref) {
  final opener = ref.watch(fileOpenServiceProvider);
  return OpenFileUseCase(opener: opener);
});

final syncStartUseCaseProvider = Provider<SyncStartUseCase>((ref) {
  final repository = ref.watch(syncRepositoryProvider);
  return SyncStartUseCase(repository: repository);
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

final setSettingsUseCaseProvider = Provider<SetSettingsUseCase>((ref) {
  final settings = ref.watch(settingsServiceProvider);
  return SetSettingsUseCase(settings: settings);
});
