import 'package:cross_platform_project/domain/entities/file_entity.dart';

class HistoryNavigator {
  final List<FileEntity> _forwardStack = [];
  final List<FileEntity> _backwardStack = [];

  bool get canGoBack => _backwardStack.length > 1;
  bool get canGoForward => _forwardStack.isNotEmpty;

  void initHistory(FileEntity root) {
    _backwardStack.add(root);
  }

  void push(FileEntity entity) {
    _backwardStack.add(entity);
    _forwardStack.clear();
  }

  FileEntity? goBack() {
    if (!canGoBack) return null;
    final current = _backwardStack.removeLast();
    _forwardStack.add(current);
    return _backwardStack.last;
  }

  FileEntity? goForward() {
    if (!canGoForward) return null;
    final current = _forwardStack.removeLast();
    _backwardStack.add(current);
    return current;
  }
}
