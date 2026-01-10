import 'dart:async';

import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/providers/settings_service_provider.dart';
import 'package:cross_platform_project/core/services/settings_service.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/file_system_scan/fs_scan_handler.dart';
import 'package:cross_platform_project/data/file_system_scan/fs_scanner_providers.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/providers/storage_operations_providers.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/copy_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/create_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/delete_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/rename_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/pick_existing_files_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/sync_start_use_case.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileOperationsState {
  final FileEntity? copyFrom;
  final bool? isCut;

  FileOperationsState({this.copyFrom, this.isCut});

  FileOperationsState copyWith({
    List<FileCreateRequest>? pendingCreateRequests,
    FileEntity? copyFrom,
    bool? isCut,
  }) {
    return FileOperationsState(
      copyFrom: copyFrom ?? this.copyFrom,
      isCut: isCut ?? this.isCut,
    );
  }
}

class FileOperationsViewModel extends Notifier<FileOperationsState> {
  CreateFileUseCase get _createFileUseCase =>
      ref.read(createFileUseCaseProvider);
  DeleteFileUseCase get _deleteFileUseCase =>
      ref.read(deleteFileUseCaseProvider);
  RenameFileUseCase get _renameFileUseCase =>
      ref.read(renameFileUseCaseProvider);
  SyncStartUseCase get _syncStartUseCase => ref.read(syncStartUseCaseProvider);
  CopyFileUseCase get _copyFileUseCase => ref.read(copyFileUseCaseProvider);
  PickExistingFilesUseCase get _pickExistingFilesUseCase =>
      ref.read(pickExistingFilesUseCaseProvider);
  FsScanHandler get _scanHandler => ref.read(fsScanHandlerProvider);
  SettingsService get _settingsService => ref.read(settingsServiceProvider);

  bool get defaultSyncEnabled => _settingsService.defaultSyncEnabled;
  bool get defaultDownloadEnabled => _settingsService.defaultDownloadEnabled;

  @override
  FileOperationsState build() {
    ref.onDispose(() => debugLog('DISPOSED: FILE OP VM'));
    return FileOperationsState();
  }

  Future<Result<void>> createFile({
    required FileEntity parent,
    required bool isFolder,
    required String name,
    required bool syncEnabled,
    required bool downloadEnabled,
  }) async {
    debugLog('VM: creating $name in ${parent.name}');
    final result = await _createFileUseCase(
      parent: parent,
      requests: [
        FileCreateRequest(
          name: name,
          isFolder: isFolder,
          downloadEnabled: downloadEnabled,
          syncEnabled: syncEnabled,
        ),
      ],
    );

    return result;
  }

  Future<Result<void>> deleteFile({required FileEntity entity}) async {
    var result = await _deleteFileUseCase(entity: entity);
    return result;
  }

  Future<Result<void>> renameFile({
    required FileEntity entity,
    required String newName,
  }) async {
    var renameResult = await _renameFileUseCase(
      entity: entity,
      newName: newName,
    );
    return renameResult;
  }

  Future<void> setPickedFiles({
    required bool pickFolder,
    required FileEntity parent,
  }) async {
    final result = await _pickExistingFilesUseCase(
      pickFolder: pickFolder,
      parent: parent,
    );
    if (result.isSuccess) {
      state = state.copyWith(pendingCreateRequests: (result as Success).data);
    }
  }

  Future<void> setCopyFrom({
    required bool isCut,
    required FileEntity copyFrom,
  }) async {
    state = state.copyWith(copyFrom: copyFrom, isCut: isCut);
  }

  Future<void> copyTo({required FileEntity folder}) async {
    if (state.copyFrom != null) {
      await _copyFileUseCase(
        copyFrom: state.copyFrom!,
        copyTo: folder,
        isCut: state.isCut!,
      );
      state = state.copyWith(isCut: null, copyFrom: null);
    }
  }

  Future<void> startSync() async {
    await _syncStartUseCase();
  }

  Future<void> startScan() async {
    _scanHandler.executeScan();
  }
}
