import 'dart:async';
import 'dart:io';

import 'package:cross_platform_project/core/services/storage_path_service.dart';

class FileSystemWatcher {
  FileSystemWatcher({required this.pathService});

  final StoragePathService pathService;
  late final StreamSubscription<FileSystemEvent>? _fsEventSub;

  void watchFS() {
    final fsEventStream = Directory(
      pathService.getRoot(),
    ).watch(recursive: true);
    _fsEventSub = fsEventStream.listen((event) => print(event.toString()));
  }
}
