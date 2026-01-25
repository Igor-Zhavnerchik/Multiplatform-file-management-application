import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/data/repositories/requests/create_file_request.dart';
import 'package:cross_platform_project/data/services/file_picker_service.dart';
import 'package:cross_platform_project/application/services/settings_service.dart';
import 'package:cross_platform_project/common/utility/result.dart';
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
    if (pickFolder) {
      final pickedFolderResult = await filePickerService.pickFolder();
      pickedFolderResult.when(
        success: (pickedFolder) async {
          await _processPickedEntities(
            parent: parent,
            pickedEntity: pickedFolder,
          );
        },
        failure: (msg, err, source) {
          debugLog('$msg error: $err source: $source');
          return Failure(msg, error: err, source: source);
        },
      );
    } else {
      final pickedFilesResult = await filePickerService.pickFiles();
      return pickedFilesResult.when(
        success: (pickedFileList) async {
          Result<void> result;
          for (var pickedfile in pickedFileList) {
            result = await _processPickedEntities(
              parent: parent,
              pickedEntity: pickedfile,
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
    return Success(null);
  }

  Future<Result<void>> _processPickedEntities({
    required FileEntity parent,
    required PickedEntity pickedEntity,
  }) async {
    switch (pickedEntity) {
      case PickedFile pickedFile:
        return await storage.createFile(
          parent: parent,
          request: FileCreateRequest(
            name: pickedFile.name,
            isFolder: false,
            localPath: pickedFile.path,
            contentSyncEnabled: settingsService.defaultContentSyncEnabled,
            bytes: pickedFile.bytes,
          ),
        );
      case PickedFolder pickedfolder:
        final newParentResult = await storage.createFile(
          parent: parent,
          request: FileCreateRequest(
            name: pickedfolder.name,
            isFolder: true,
            localPath: pickedfolder.path,
            contentSyncEnabled: settingsService.defaultContentSyncEnabled,
          ),
        );
        newParentResult.when(
          success: (newParent) async {
            for (var child in pickedfolder.children) {
              await _processPickedEntities(
                parent: newParent,
                pickedEntity: child,
              );
            }
            return Success(null);
          },
          failure: (msg, err, source) =>
              Failure(msg, error: err, source: source),
        );
    }
    return Success(null);
  }
}
