import 'package:cross_platform_project/data/file_system_scan/file_system_watcher.dart';
import 'package:cross_platform_project/data/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fileSystemWatcherProvider = Provider<FileSystemWatcher>((ref) {
  final pathService = ref.watch(storagePathServiceProvider);
  return FileSystemWatcher(pathService: pathService);
});
