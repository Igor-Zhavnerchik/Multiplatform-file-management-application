import 'dart:async';
import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/providers/file_stream_providers.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/providers/storage_operations_providers.dart';
import 'package:cross_platform_project/domain/use_cases/utils/get_root_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/open_file_use_case.dart';
import 'package:cross_platform_project/presentation/providers/history_navigator_provider.dart';
import 'package:cross_platform_project/presentation/services/history_navigator.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewState {
  bool canGoBack;
  bool canGoForward;

  FileEntity? selected;
  FileEntity? currentFolder;

  HomeViewState({
    this.selected,
    this.currentFolder,
    this.canGoBack = false,
    this.canGoForward = false,
  });

  HomeViewState copyWith({
    FileEntity? selected,
    FileEntity? currentFolder,
    bool? canGoBack,
    bool? canGoForward,
  }) {
    return HomeViewState(
      selected: selected ?? this.selected,
      currentFolder: currentFolder ?? this.currentFolder,
      canGoBack: canGoBack ?? this.canGoBack,
      canGoForward: canGoForward ?? this.canGoForward,
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
    return HomeViewState();
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
        failure: (msg, err, source) =>
            debugLog('$msg error: $err source: $source '),
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
}
