import 'dart:io';
import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/data/data_source/local/local_file_id_service.dart/local_file_id_service.dart';

sealed class FSEntry {
  final String path;
  final String localFileId;

  final String? parentLocalFileId;

  FSEntry({
    required this.localFileId,
    required this.path,
    this.parentLocalFileId,
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
  });
}

class ExistingFolder extends FSEntry {
  ExistingFolder({
    required super.localFileId,
    required super.parentLocalFileId,
    required super.path,
  });
}

//FIXME may not be needed
class MissingEntry extends FSEntry {
  MissingEntry({super.localFileId = '', required super.path});
}

class FileSystemScanner {
  FileSystemScanner({required this.localFileIdService});

  final LocalFileIdService localFileIdService;

  Future<Map<String, FSEntry>> scan({
    required String path,
    String? fromParent,
  }) async {
    debugLog('scanning: $path');
    final Map<String, FSEntry> entries = {};
    final localFileId = await localFileIdService.getFileId(path: path);
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
        );
      } else {
        entries[localFileId] = ExistingFolder(
          path: path,
          localFileId: localFileId,
          parentLocalFileId: fromParent,
        );
        await for (var file in Directory(path).list()) {
          entries.addAll(await scan(path: file.path));
        }
      }
    }

    return entries;
  }
}
