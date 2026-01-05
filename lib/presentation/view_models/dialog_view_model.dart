import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DialogState {
  final bool isVisible;
  final Offset? position;
  final Widget? content;

  DialogState({required this.isVisible, this.position, this.content});
}

class DialogViewModel extends Notifier<DialogState> {
  @override
  DialogState build() {
    return DialogState(isVisible: false);
  }

  void showCustomDialog({required Widget content, Offset? position}) {
    debugLog('showing dialog ${content.toString()}');
    state = DialogState(isVisible: true, content: content, position: position);
  }

  void hide() {
    state = DialogState(isVisible: false);
    debugLog('dialog is hidden');
  }
}

class ContextDialogAction {
  final String title;
  final Icon? icon;
  final VoidCallback action;
  final bool isDestructive;

  ContextDialogAction({
    required this.title,
    required this.action,
    this.icon,
    this.isDestructive = false,
  });
}
