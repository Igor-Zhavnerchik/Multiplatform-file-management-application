import 'dart:async';

import 'package:cross_platform_project/application/fs_scan/fs_scan_handler_provider.dart';
import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/application/providers/settings_service_provider.dart';
import 'package:cross_platform_project/application/services/settings_service.dart';
import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/application/fs_scan/fs_scan_handler.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/providers/storage_operations_providers.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/copy_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/create_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/delete_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/update_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/pick_existing_files_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/sync_start_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/utils_use_cases_providers.dart';

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
  UpdateFileUseCase get _updateFileUseCase =>
      ref.read(updateFileUseCaseProvider);
  SyncStartUseCase get _syncStartUseCase => ref.read(syncStartUseCaseProvider);
  CopyFileUseCase get _copyFileUseCase => ref.read(copyFileUseCaseProvider);
  PickExistingFilesUseCase get _pickExistingFilesUseCase =>
      ref.read(pickExistingFilesUseCaseProvider);
  FsScanHandler get _scanHandler => ref.read(fsScanHandlerProvider);
  SettingsService get _settingsService => ref.read(settingsServiceProvider);

  bool get defaultContentSyncEnabled =>
      _settingsService.defaultContentSyncEnabled;

  @override
  FileOperationsState build() {
    ref.onDispose(() => debugLog('DISPOSED: FILE OP VM'));
    return FileOperationsState();
  }

  Future<Result<void>> createFile({
    required FileEntity parent,
    required bool isFolder,
    required String name,
    required bool contentSyncEnabled,
  }) async {
    debugLog('VM: creating $name in ${parent.name}');
    final result = await _createFileUseCase(
      parent: parent,
      requests: [
        FileCreateRequest(
          name: name,
          isFolder: isFolder,
          contentSyncEnabled: contentSyncEnabled,
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
    var renameResult = await _updateFileUseCase(
      entity: entity,
      newName: newName,
    );
    return renameResult;
  }

  Future<Result<void>> setContentSyncEnabled({
    required FileEntity entity,
    required bool isEnabled,
  }) async {
    var renameResult = await _updateFileUseCase(
      entity: entity,
      contentSyncEnabled: isEnabled,
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
      debugLog('copy started');
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
