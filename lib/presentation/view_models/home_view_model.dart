import 'dart:async';
import 'dart:ui';
import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/providers/file_stream_providers.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/providers/storage_operations_providers.dart';
import 'package:cross_platform_project/domain/use_cases/utils/get_root_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/open_file_use_case.dart';
import 'package:cross_platform_project/presentation/dialog/file_operation_dialog.dart';
import 'package:cross_platform_project/presentation/providers/history_navigator_provider.dart';
import 'package:cross_platform_project/presentation/services/history_navigator.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewState {
  bool openDialog;
  bool canGoBack;
  bool canGoForward;
  ContextDialogType? dialog;
  Offset? dialogPosition;

  FileEntity? selected;
  FileEntity? currentFolder;

  HomeViewState({
    this.selected,
    this.currentFolder,
    required this.openDialog,
    this.dialog,
    this.dialogPosition,
    this.canGoBack = false,
    this.canGoForward = false,
  });

  HomeViewState copyWith({
    FileEntity? selected,
    FileEntity? currentFolder,
    ContextDialogType? dialog,
    bool? openDialog,
    bool? canGoBack,
    bool? canGoForward,
    Offset? dialogPosition,
  }) {
    return HomeViewState(
      selected: selected ?? this.selected,
      currentFolder: currentFolder ?? this.currentFolder,
      dialog: dialog ?? this.dialog,
      openDialog: openDialog ?? this.openDialog,
      canGoBack: canGoBack ?? this.canGoBack,
      canGoForward: canGoForward ?? this.canGoForward,
      dialogPosition: dialogPosition ?? this.dialogPosition,
    );
  }
}

class HomeViewModel extends Notifier<HomeViewState> {
  OpenFileUseCase get _openFileUseCase => ref.read(openFileUseCaseProvider);
  HistoryNavigator get _historyNavigator => ref.read(historyNavigatorProvider);
  GetRootUseCase get _getRootUseCase => ref.read(getRootUseCaseProvider);
  @override
  HomeViewState build() {
    ref.listen<AsyncValue<List<FileEntity>>>(onlyFoldersListProvider(null), (
      prev,
      next,
    ) {
      next.whenData((data) {
        if (state.currentFolder == null && data.isNotEmpty) {
          setCurrentFolder(data.first);
          _historyNavigator.initHistory(data.first);
        }
      });
    });
    return HomeViewState(openDialog: false);
  }

  @deprecated
  Future<FileEntity> getRoot() async {
    return (await _getRootUseCase() as Success).data;
  }

  Future<void> setSelected(FileEntity selectedItem) async {
    state = (state.copyWith(selected: selectedItem));
    print('selected: ${selectedItem.name}');
  }

  Future<void> setCurrentFolder(FileEntity currentFolder) async {
    state = (state.copyWith(currentFolder: currentFolder));
    print(
      'current folder: ${currentFolder.name} owner: ${currentFolder.ownerId}',
    );
    final children = ref.read(childrenListProvider(currentFolder.id));
    children.whenData(
      (data) => {
        for (var child in data) {debugLog(child.name)},
      },
    );
  }

  Future<void> openElement(FileEntity element) async {
    if (element.isFolder) {
      _historyNavigator.push(element);
      await setCurrentFolder(element);
      await setSelected(element);
      state = state.copyWith(
        canGoBack: _historyNavigator.canGoBack,
        canGoForward: _historyNavigator.canGoForward,
      );
    } else {
      (await _openFileUseCase.call(file: element)).when(
        success: (_) => debugLog('Successfully opened ${element.name}'),
        failure: (failure, _) => debugLog(failure),
      );
    }
  }

  Future<void> goBack() async {
    final previous = _historyNavigator.goBack();
    debugLog('Go back to: ${previous?.name}');
    if (previous != null) {
      await setCurrentFolder(previous);
      state = state.copyWith(
        canGoBack: _historyNavigator.canGoBack,
        canGoForward: _historyNavigator.canGoForward,
      );
    }
  }

  Future<void> goForward() async {
    final next = _historyNavigator.goForward();
    debugLog('Go forward to: ${next?.name}');
    if (next != null) {
      await setCurrentFolder(next);
      state = state.copyWith(
        canGoBack: _historyNavigator.canGoBack,
        canGoForward: _historyNavigator.canGoForward,
      );
    }
  }

  Future<void> clearDialog() async {
    state = state.copyWith(
      openDialog: false,
      dialog: null,
      dialogPosition: null,
    );
  }

  Future<void> setDialog(
    ContextDialogType dialog, {
    Offset? dialogPosition,
  }) async {
    state = state.copyWith(
      openDialog: true,
      dialog: dialog,
      dialogPosition: dialogPosition,
    );
  }
}
