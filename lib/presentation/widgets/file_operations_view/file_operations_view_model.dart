import 'dart:async';

import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/providers/settings_service_provider.dart';
import 'package:cross_platform_project/core/services/settings_service.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/file_system_scan/fs_scan_handler.dart';
import 'package:cross_platform_project/data/file_system_scan/fs_scanner_providers.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/providers/storage_operations_providers.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/copy_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/create_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/delete_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/crud_operations/rename_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/pick_existing_files_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/sync_start_use_case.dart';
import 'package:cross_platform_project/presentation/providers/home_view_model_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileCreateRequest {
  final String? localPath;
  final Stream<List<int>>? bytes;
  final String name;
  final bool isFolder;
  final bool downloadEnabled;
  final bool syncEnabled;

  FileCreateRequest({
    required this.name,
    this.localPath,
    this.bytes,
    required this.isFolder,
    required this.downloadEnabled,
    required this.syncEnabled,
  });

  FileCreateRequest copyWith({
    String? localPath,
    Stream<List<int>>? bytes,
    String? name,
    bool? isFolder,
    bool? downloadEnabled,
    bool? syncEnabled,
  }) {
    return FileCreateRequest(
      name: name ?? this.name,
      localPath: localPath ?? this.localPath,
      bytes: bytes ?? this.bytes,
      isFolder: isFolder ?? this.isFolder,
      downloadEnabled: downloadEnabled ?? this.downloadEnabled,
      syncEnabled: syncEnabled ?? this.syncEnabled,
    );
  }
}

class FileOperationsState {
  final List<FileCreateRequest> pendingCreateRequests;
  final FileEntity? copyFrom;
  final bool? isCut;

  FileOperationsState({
    this.pendingCreateRequests = const [],
    this.copyFrom,
    this.isCut,
  });

  FileOperationsState copyWith({
    List<FileCreateRequest>? pendingCreateRequests,
    FileEntity? copyFrom,
    bool? isCut,
  }) {
    return FileOperationsState(
      pendingCreateRequests:
          pendingCreateRequests ?? this.pendingCreateRequests,
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
      ref.read(updateFileUseCaseProvider);
  SyncStartUseCase get _syncStartUseCase => ref.read(syncStartUseCaseProvider);
  CopyFileUseCase get _copyFileUseCase => ref.read(copyFileUseCaseProvider);
  PickExistingFilesUseCase get _pickExistingFilesUseCase =>
      ref.read(pickExistingFilesUseCaseProvider);
  FsScanHandler get _scanHandler => ref.read(fsScanHandlerProvider);
  SettingsService get _settingsService => ref.read(settingsServiceProvider);

  FileCreateRequest get emptyRequest => FileCreateRequest(
    name: '',
    isFolder: false,
    syncEnabled: _settingsService.defaultSyncEnabled,
    downloadEnabled: _settingsService.defaultDownloadEnabled,
  );

  @override
  FileOperationsState build() {
    return FileOperationsState(pendingCreateRequests: [emptyRequest]);
  }

  void _setDefaultCreateRequest() {
    state = state.copyWith(pendingCreateRequests: [emptyRequest]);
  }

  Future<void> createFile({required FileEntity parent}) async {
    if (state.pendingCreateRequests.first.name.isNotEmpty) {
      final result = await _createFileUseCase(
        parent: parent,
        requests: state.pendingCreateRequests,
      );

      _setDefaultCreateRequest();
    }
  }

  Future<void> deleteFile() async {
    var deleted = await _deleteFileUseCase(
      entity: ref.read(homeViewModelProvider).selected!,
    );
    debugLog('in delete file. deleted: $deleted');
  }

  Future<void> renameFile({
    required FileEntity entity,
    required String newName,
  }) async {
    var renameResult = await _renameFileUseCase(
      entity: entity,
      newName: newName,
    );
    _setDefaultCreateRequest();
  }

  Future<void> setNewFileState({
    String? name,
    bool? isFolder,
    bool? downloadEnabled,
    bool? syncEnabled,
  }) async {
    final currentRequest = state.pendingCreateRequests.first;
    state = state.copyWith(
      pendingCreateRequests: [
        currentRequest.copyWith(
          name: name,
          isFolder: isFolder,
          downloadEnabled: downloadEnabled,
          syncEnabled: syncEnabled,
        ),
      ],
    );
  }

  Future<void> setPickedFiles({required bool pickFolder}) async {
    final result = await _pickExistingFilesUseCase(pickFolder: pickFolder);
    if (result.isSuccess) {
      state = state.copyWith(pendingCreateRequests: (result as Success).data);
    }
  }

  Future<void> setCopyFrom({required bool isCut}) async {
    state = state.copyWith(
      copyFrom: ref.read(homeViewModelProvider).selected!,
      isCut: isCut,
    );
  }

  Future<void> copyTo() async {
    if (state.copyFrom != null) {
      await _copyFileUseCase(
        copyFrom: state.copyFrom!,
        copyTo: ref.read(homeViewModelProvider).currentFolder!,
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
