import 'package:cross_platform_project/core/services/file_picker_service.dart';
import 'package:cross_platform_project/core/services/settings_service.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/presentation/widgets/file_operations_view/file_operations_view_model.dart';

class PickExistingFilesUseCase {
  final FilePickerService filePickerService;
  final SettingsService settingsService;

  PickExistingFilesUseCase({
    required this.filePickerService,
    required this.settingsService,
  });

  Future<Result<List<FileCreateRequest>>> call({
    required bool pickFolder,
  }) async {
    final pickedFilesResult = pickFolder
        ? await filePickerService.pickFolder()
        : await filePickerService.pickFiles();
    if (pickedFilesResult.isSuccess) {
      final requests = ((pickedFilesResult as Success).data as List<PickedFile>)
          .map(
            (file) => FileCreateRequest(
              name: file.name,
              isFolder: file.isFolder,
              localPath: file.path,
              downloadEnabled: settingsService.defaultDownloadEnabled,
              syncEnabled: settingsService.defaultSyncEnabled,
            ),
          )
          .toList();
      return Success(requests);
    }
    return Failure(
      'failed to pick files',
      error: (pickedFilesResult as Failure).error,
      source: 'PickExistingFilesUseCase',
    );
  }
}
