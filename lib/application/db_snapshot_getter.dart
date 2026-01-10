import 'package:cross_platform_project/data/data_source/local/database/dao/files_dao.dart';

class DbSnapshotEntry {
  final String fileId;
  final String localFileId;
  final String? parentId;
  final String? parentLocalFileId;

  final String name;
  final bool isFolder;

  final int? size;
  final String? hash;

  DbSnapshotEntry({
    required this.fileId,
    required this.localFileId,
    required this.parentId,
    required this.parentLocalFileId,
    required this.name,
    required this.isFolder,
    this.size,
    this.hash,
  });
}

class DbSnapshotGetter {
  final FilesDao filesTable;

  DbSnapshotGetter({required this.filesTable});

  Future<Map<String, DbSnapshotEntry>> getDbSnapshot() async {
    final dbFiles = await filesTable.getAllFiles();

    return {
      for (final file in dbFiles)
        file.localFileId: DbSnapshotEntry(
          fileId: file.id,
          localFileId: file.localFileId,
          parentId: file.parentId,
          parentLocalFileId: file.parentId == null
              ? null
              : dbFiles.firstWhere((e) => e.id == file.parentId).localFileId,
          name: file.name,
          isFolder: file.isFolder,
          size: file.size,
          hash: file.hash,
        ),
    };
  }
}
