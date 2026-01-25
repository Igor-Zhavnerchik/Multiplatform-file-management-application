import 'dart:async';
import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/application/providers/settings_service_provider.dart';
import 'package:cross_platform_project/data/providers/file_stream_providers.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/use_cases/utils/open_file_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/set_settings_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/utils/utils_use_cases_providers.dart';
import 'package:cross_platform_project/presentation/providers/history_navigator_provider.dart';
import 'package:cross_platform_project/presentation/services/history_navigator.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewState {
  bool canGoBack;
  bool canGoForward;

  FileEntity? selected;
  FileEntity? currentFolder;
  bool defaultDownloadEnabled;

  HomeViewState({
    this.selected,
    this.currentFolder,
    this.canGoBack = false,
    this.canGoForward = false,
    this.defaultDownloadEnabled = false,
  });

  HomeViewState copyWith({
    FileEntity? selected,
    FileEntity? currentFolder,
    bool? canGoBack,
    bool? canGoForward,
    bool? defaultDownloadEnabled,
  }) {
    return HomeViewState(
      selected: selected ?? this.selected,
      currentFolder: currentFolder ?? this.currentFolder,
      canGoBack: canGoBack ?? this.canGoBack,
      canGoForward: canGoForward ?? this.canGoForward,
      defaultDownloadEnabled:
          defaultDownloadEnabled ?? this.defaultDownloadEnabled,
    );
  }
}

class HomeViewModel extends Notifier<HomeViewState> {
  OpenFileUseCase get _openFileUseCase => ref.read(openFileUseCaseProvider);
  SetSettingsUseCase get _setSettingsUseCase =>
      ref.read(setSettingsUseCaseProvider);
  HistoryNavigator get _historyNavigator => ref.read(historyNavigatorProvider);

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
    ref.listen<AsyncValue<bool>>(settingsStreamProvider, (prev, next) {
      next.whenData((value) {
        state = state.copyWith(defaultDownloadEnabled: value);
        debugLog('HomeViewModel: defaultDownloadEnabled updated to $value');
      });
    });

    return HomeViewState();
  }

  Future<void> setSelected(FileEntity? selectedItem) async {
    state = (state.copyWith(selected: selectedItem));
    print('selected: ${selectedItem?.name}');
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

  Future<void> toggleDefaultContentSync(bool value) async {
    final result = await _setSettingsUseCase.call(
      defaultContentSyncEnabled: value,
    );

    result.when(
      success: (_) => debugLog('Setting updated successfully'),
      failure: (msg, err, src) => debugLog('Failed to update setting: $msg'),
    );
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
