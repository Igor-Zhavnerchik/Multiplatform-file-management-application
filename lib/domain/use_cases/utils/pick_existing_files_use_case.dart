import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/services/file_picker_service.dart';
import 'package:cross_platform_project/core/services/settings_service.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';

class PickExistingFilesUseCase {
  final FilePickerService filePickerService;
  final SettingsService settingsService;
  final StorageRepository storage;

  PickExistingFilesUseCase({
    required this.filePickerService,
    required this.settingsService,
    required this.storage,
  });

  Future<Result<void>> call({
    required bool pickFolder,
    required FileEntity parent,
  }) async {
    final pickedFilesResult = pickFolder
        ? await filePickerService.pickFolder()
        : await filePickerService.pickFiles();
    return pickedFilesResult.when(
      success: (pickedFileList) async {
        Result<void> result;
        for (var pickedfile in pickedFileList) {
          result = await storage.createFile(
            parent: parent,
            request: FileCreateRequest(
              name: pickedfile.name,
              isFolder: pickedfile.isFolder,
              localPath: pickedfile.path,
              downloadEnabled: settingsService.defaultDownloadEnabled,
              syncEnabled: settingsService.defaultSyncEnabled,
              bytes: pickedfile.bytes,
            ),
          );
          if (result.isFailure) {
            return result;
          }
        }
        return Success(null);
      },
      failure: (msg, err, source) {
        debugLog('$msg error: $err source: $source');
        return Failure(msg, error: err, source: source);
      },
    );
  }
}
