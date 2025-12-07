import 'dart:async';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/providers/storage_operations_providers.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewState {
  FileEntity? currentFolder;
  FileEntity? selected;

  HomeViewState({this.currentFolder, this.selected});

  HomeViewState copyWith({FileEntity? currentFolder, FileEntity? selected}) {
    return HomeViewState(
      currentFolder: currentFolder ?? this.currentFolder,
      selected: selected ?? this.selected,
    );
  }
}

class HomeViewModel extends Notifier<HomeViewState> {
  @override
  HomeViewState build() {
    return HomeViewState();
  }

  Future<void> setCurrentFolder(FileEntity currentFolder) async {
    state = (state.copyWith(currentFolder: currentFolder));
  }

  Future<void> setSelected(FileEntity selectedItem) async {
    state = (state.copyWith(selected: selectedItem));
  }

  Future<void> openElement(FileEntity element) async {
    if (element.isFolder) {
      setCurrentFolder(element);
    }
  }
}
