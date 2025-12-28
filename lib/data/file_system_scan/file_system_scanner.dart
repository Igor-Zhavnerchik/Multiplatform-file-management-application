import 'dart:io';
import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/services/storage_path_service.dart';
import 'package:cross_platform_project/data/data_source/local/local_file_id_service.dart/local_file_id_service.dart';

sealed class FSEntry {
  final String path;
  final String localFileId;

  final String? parentLocalFileId;
  final int depth;

  FSEntry({
    required this.localFileId,
    required this.path,
    this.parentLocalFileId,
    required this.depth,
  });
}

class ExistingFile extends FSEntry {
  final int size;
  final DateTime modifiedAt;

  ExistingFile({
    required super.path,
    required super.localFileId,
    required super.parentLocalFileId,
    required this.size,
    required this.modifiedAt,
    required super.depth,
  });
}

class ExistingFolder extends FSEntry {
  ExistingFolder({
    required super.localFileId,
    required super.parentLocalFileId,
    required super.path,
    required super.depth,
  });
}

class FileSystemScanner {
  FileSystemScanner({
    required this.localFileIdService,
    required this.pathService,
  });

  final LocalFileIdService localFileIdService;
  final StoragePathService pathService;

  Future<Map<String, FSEntry>> scan() async {
    final Map<String, FSEntry> entries = {};
    final userPaths = await pathService.getUsersStorageDirectories();
    Directory userDir;
    for (var userPath in userPaths) {
      debugLog('scanning user path $userPath');
      userDir = Directory(userPath);
      await for (var file in userDir.list()) {
        entries.addAll(await _scanUserPath(path: file.path, depth: 0));
      }
    }
    return entries;
  }

  Future<Map<String, FSEntry>> _scanUserPath({
    required String path,
    required int depth,
    String? fromParent,
  }) async {
    debugLog('scanning: $path');
    final Map<String, FSEntry> entries = {};
    final localFileId = await localFileIdService.getFileId(path: path);
    debugLog('path: $path id: $localFileId');
    if (localFileId.isEmpty) {
      throw Exception('file id does not exists. path: $path ');
    } else {
      final file = File(path);
      if (await file.exists()) {
        entries[localFileId] = ExistingFile(
          path: path,
          localFileId: localFileId,
          parentLocalFileId: fromParent,
          size: await file.length(),
          modifiedAt: await file.lastModified(),
          depth: depth,
        );
      } else {
        entries[localFileId] = ExistingFolder(
          path: path,
          localFileId: localFileId,
          parentLocalFileId: fromParent,
          depth: depth,
        );
        await for (var file in Directory(path).list()) {
          entries.addAll(
            await _scanUserPath(
              path: file.path,
              depth: depth + 1,
              fromParent: localFileId,
            ),
          );
        }
      }
    }
    return entries;
  }
}
