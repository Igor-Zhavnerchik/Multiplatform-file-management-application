import 'dart:io';
import 'dart:typed_data';

import 'package:cross_platform_project/data/services/storage_path_service.dart';
import 'package:cross_platform_project/common/utility/result.dart';
import 'package:file_picker/file_picker.dart';

sealed class PickedEntity {
  final String? path;
  final String name;
  PickedEntity({required this.path, required this.name});
}

class PickedFile extends PickedEntity {
  final Stream<Uint8List>? bytes;

  PickedFile({required super.path, required super.name, this.bytes});
}

class PickedFolder extends PickedEntity {
  final List<PickedEntity> children;

  PickedFolder({
    required super.path,
    required super.name,
    required this.children,
  });
}

class FilePickerService {
  final StoragePathService pathService;

  FilePickerService({required this.pathService});

  Future<Result<List<PickedFile>>> pickFiles() async {
    final List<PickedFile> pickedFiles = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null && result.files.isNotEmpty) {
      for (var file in result.files) {
        pickedFiles.add(PickedFile(path: file.path, name: file.name));
      }
      return Success(pickedFiles);
    } else {
      return Failure('No files were selected.');
    }
  }

  Future<Result<PickedFolder>> pickFolder() async {
    String? selectedFolderPath = await FilePicker.platform.getDirectoryPath();

    if (selectedFolderPath != null) {
      final pickedFolder = PickedFolder(
        path: selectedFolderPath,
        name: pathService.getName(selectedFolderPath),
        children: await _getFilesInPickedFolder(path: selectedFolderPath),
      );
      return Success(pickedFolder);
    } else {
      return Failure('No folder was selected.');
    }
  }

  Future<List<PickedEntity>> _getFilesInPickedFolder({
    required String path,
  }) async {
    final folder = Directory(path);
    final List<PickedEntity> files = [];
    await for (final entity in folder.list()) {
      switch (entity) {
        case File file:
          files.add(
            PickedFile(path: file.path, name: pathService.getName(file.path)),
          );
        case Directory folder:
          files.add(
            PickedFolder(
              path: folder.path,
              name: pathService.getName(folder.path),
              children: await _getFilesInPickedFolder(path: folder.path),
            ),
          );
      }
    }

    return files;
  }
}
