import 'dart:async';
import 'dart:io';

import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/data/services/storage_path_service.dart';
import 'package:cross_platform_project/application/fs_scan/fs_scan_handler.dart';

class FileSystemWatcher {
  FileSystemWatcher({required this.pathService, required this.scanHandler});

  final StoragePathService pathService;
  final FsScanHandler scanHandler;
  StreamSubscription<FileSystemEvent>? _fsEventSub;
  Timer? _idleTimer;

  void watchFS() {
    final fsEventStream = Directory(
      pathService.getRoot(),
    ).watch(recursive: true);
    _fsEventSub = fsEventStream.listen((event) {
      debugLog(event.toString());
      _idleTimer?.cancel();
      _idleTimer = Timer(
        Duration(seconds: 2),
        () async => await scanHandler.executeScan(),
      );
    });
  }

  void dispose() {
    _idleTimer?.cancel();
    _fsEventSub?.cancel();
  }
}
