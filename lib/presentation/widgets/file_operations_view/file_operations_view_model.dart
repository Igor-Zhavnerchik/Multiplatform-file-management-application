import 'dart:async';
import 'dart:io';

import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/providers/storage_operations_providers.dart';
import 'package:cross_platform_project/domain/use_cases/create_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/delete_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/sync_start_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/update_file_use_case.dart';
import 'package:cross_platform_project/presentation/providers/home_view_model_provider.dart';
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

class FileOperationsViewModel extends Notifier<FileOperationsState> {
  late final CreateFileUseCase _createFileUseCase;
  late final DeleteFileUseCase _deleteFileUseCase;
  late final UpdateFileUseCase _updateFileUseCase;
  late final SyncStartUseCase _syncStartUseCase;

  @override
  FileOperationsState build() {
    _createFileUseCase = ref.read(createFileUseCaseProvider);
    _deleteFileUseCase = ref.read(deleteFileUseCaseProvider);
    _updateFileUseCase = ref.read(updateFileUseCaseProvider);
    _syncStartUseCase = ref.read(syncStartUseCaseProvider);

    return FileOperationsState();
  }

  Future<void> createFile({required bool? isFolder}) async {
    if (state.newFileName.isNotEmpty) {
      debugLog('created ${state.newFileIsFolder ? 'folder' : 'file'}');
      debugLog('in ${ref.read(homeViewModelProvider).currentFolder!.id}');
      final result = await _createFileUseCase(
        parentId: ref.read(homeViewModelProvider).currentFolder!.id,
        name: state.newFileName,
        isFolder: isFolder ?? state.newFileIsFolder,
        fileLocalPath: state.newFileLocalPath,
        downloadEnabled: state.newFileDownloadEnabled,
        syncEnabled: state.newFileSyncEnabled,
      );
      switch (result) {
        case Failure f:
          debugLog('${f.message} error: ${f.error} source: ${f.source}');
        case Success s:
          debugLog('successfully created ${state.newFileName}');
      }
      state.copyWith(
        newFileLocalPath: '',
        newFileName: '',
        newFileIsFolder: null,
        newFileDownloadEnabled: true,
        newFileSyncEnabled: true,
      );
    }
  }

  Future<void> deleteFile() async {
    var deleted = await _deleteFileUseCase(
      entity: ref.read(homeViewModelProvider).selected!,
    );
    debugLog('in delete file. deleted: $deleted');
  }

  Future<void> updateFile({required FileEntity toUpdate}) async {
    var updated = await _updateFileUseCase(entity: toUpdate);
    debugLog('in update file. updated: $updated');
  }

  Future<void> setNewFileState({
    String? name,
    String? path,
    bool? isFolder,
  }) async {
    state = state.copyWith(
      newFileName: name,
      newFileLocalPath: path,
      newFileIsFolder: isFolder,
    );
  }

  Future<void> getNewFilePath() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      await setNewFileState(
        path: result.files.first.path,
        name: result.files.first.name,
        isFolder: Directory(result.files.first.path!).existsSync(),
      );
    }
  }

  Future<void> startSync() async {
    await _syncStartUseCase();
  }
}
