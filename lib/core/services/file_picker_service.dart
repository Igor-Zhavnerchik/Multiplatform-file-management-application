import 'dart:typed_data';

import 'package:cross_platform_project/core/utility/result.dart';
import 'package:file_picker/file_picker.dart';

class PickedFile {
  final String? path;
  final String name;
  final bool isFolder;
  final Stream<Uint8List>? bytes;

  PickedFile({
    required this.path,
    required this.name,
    required this.isFolder,
    this.bytes,
  });
}

class FilePickerService {
  Future<Result<List<PickedFile>>> pickFiles() async {
    final List<PickedFile> pickedFiles = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null && result.files.isNotEmpty) {
      for (var file in result.files) {
        pickedFiles.add(
          PickedFile(path: file.path, name: file.name, isFolder: false,),
        );
      }
      return Success(pickedFiles);
    } else {
      return Failure('No files were selected.');
    }
  }

  Future<Result<List<PickedFile>>> pickFolder() async {
    String? selectedFolder = await FilePicker.platform.getDirectoryPath();
    if (selectedFolder != null) {
      final pickedFolder = PickedFile(
        path: selectedFolder,
        name: selectedFolder.split('/').last,
        isFolder: true,
      );
      return Success([pickedFolder]);
    } else {
      return Failure('No folder was selected.');
    }
  }
}
