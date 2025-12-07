import 'dart:async';

import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/providers/storage_operations_providers.dart';
import 'package:cross_platform_project/domain/use_cases/create_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/delete_file_use_case.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FileOperation { delete, create }

class FileOperationDTO {
  final FileEntity selectedFile;
  final FileOperation fileOperation;

  FileOperationDTO({required this.selectedFile, required this.fileOperation});
}

class FileOperationsState {
  final String newFileName;
  final String newFileLocalPath;
  final bool newFileSyncEnabled;
  final bool newFileDownloadEnabled;
  final bool newFileIsFolder;

  FileOperationsState({
    this.newFileName = '',
    this.newFileLocalPath = '',
    this.newFileSyncEnabled = true,
    this.newFileDownloadEnabled = true,
    this.newFileIsFolder = false,
  });

  FileOperationsState copyWith({
    String? newFileName,
    String? newFileLocalPath,
    bool? newFileSyncEnabled,
    bool? newFileDownloadEnabled,
    bool? newFileIsFolder,
  }) {
    return FileOperationsState(
      newFileName: newFileName ?? this.newFileName,
      newFileLocalPath: newFileLocalPath ?? this.newFileLocalPath,
      newFileSyncEnabled: newFileSyncEnabled ?? this.newFileSyncEnabled,
      newFileDownloadEnabled:
          newFileDownloadEnabled ?? this.newFileDownloadEnabled,
      newFileIsFolder: newFileIsFolder ?? this.newFileIsFolder,
    );
  }
}

class FileOperationsViewModel extends AsyncNotifier<FileOperationsState> {
  late final CreateFileUseCase _createFileUseCase;
  late final DeleteFileUseCase _deleteFileUseCase;

  @override
  Future<FileOperationsState> build() async {
    _createFileUseCase = ref.read(createFileUseCaseProvider);
    _deleteFileUseCase = ref.read(deleteFileUseCaseProvider);

    return FileOperationsState();
  }

  Future<void> createFile({required FileEntity parent}) async {
    if (state.value != null && state.value!.newFileName.isNotEmpty) {
      debugLog('created folder: ${state.value!.newFileIsFolder}');
      await _createFileUseCase(
        parentId: parent.id,
        name: state.value!.newFileName,
        isFolder: state.value!.newFileIsFolder,
        fileLocalPath: state.value!.newFileLocalPath,
        downloadEnabled: state.value!.newFileDownloadEnabled,
        syncEnabled: state.value!.newFileSyncEnabled,
      );
    }
  }

  Future<void> deleteFile({required FileEntity toDelete}) async {
    var deleted = await _deleteFileUseCase(entity: toDelete);
    debugLog('in delete file. deleted: $deleted');
  }

  Future<void> setNewFileState({
    String? name,
    String? path,
    bool? isFolder,
  }) async {
    state = AsyncData(
      state.value!.copyWith(
        newFileName: name,
        newFileLocalPath: path,
        newFileIsFolder: isFolder,
      ),
    );
  }

  Future<void> getNewFilePath() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      await setNewFileState(path: result.files.first.path);
    }
  }
}
