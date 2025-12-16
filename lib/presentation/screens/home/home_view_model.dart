import 'dart:async';
import 'dart:ui';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/presentation/dialog/file_operation_dialog.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewState {
  bool openDialog;
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
  });

  HomeViewState copyWith({
    FileEntity? selected,
    FileEntity? currentFolder,
    ContextDialogType? dialog,
    bool? openDialog,
    Offset? dialogPosition,
  }) {
    return HomeViewState(
      selected: selected ?? this.selected,
      currentFolder: currentFolder ?? this.currentFolder,
      dialog: dialog ?? this.dialog,
      openDialog: openDialog ?? this.openDialog,
      dialogPosition: dialogPosition ?? this.dialogPosition,
    );
  }
}

class HomeViewModel extends Notifier<HomeViewState> {
  @override
  HomeViewState build() {
    return HomeViewState(openDialog: false);
  }

  Future<void> setSelected(FileEntity selectedItem) async {
    state = (state.copyWith(selected: selectedItem));
    print('selected: ${selectedItem.name}');
  }

  Future<void> setCurrentFolder(FileEntity currentFolder) async {
    state = (state.copyWith(currentFolder: currentFolder));
    print('current folder: ${currentFolder.name}');
  }

  Future<void> openElement(FileEntity element) async {
    if (element.isFolder) {
      setCurrentFolder(element);
      setSelected(element);
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
