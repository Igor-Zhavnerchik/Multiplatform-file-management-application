import 'dart:io';

import 'package:cross_platform_project/application/db_snapshot_getter.dart';
import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/services/storage_path_service.dart';
import 'package:cross_platform_project/data/data_source/local/local_data_source.dart';
import 'package:cross_platform_project/data/file_system_scan/file_system_scanner.dart';
import 'package:cross_platform_project/data/services/hash_service.dart';

sealed class DbChange {
  final int depth;
  DbChange({required this.depth});
}

class DbUpdate extends DbChange {
  DbUpdate({
    required this.fs,
    required this.file,
    required this.hash,
    required super.depth,
  });
  final DbSnapshotEntry file;
  final FSEntry fs;
  final String? hash;
}

class DbCreate extends DbChange {
  DbCreate({required this.fs, required this.hash, required super.depth});
  final FSEntry fs;
  final String? hash;
}

class DbDelete extends DbChange {
  DbDelete({required this.file, required super.depth});
  final DbSnapshotEntry file;
}

class Reconciler {
  Reconciler({
    required this.hashService,
    required this.pathService,
    required this.localDataSource,
  });
  final HashService hashService;
  final StoragePathService pathService;
  final LocalDataSource localDataSource;

  Future<List<DbChange>> detectDbChanges({
    required Map<String, DbSnapshotEntry> dbSnapshot,
    required Map<String, FSEntry> fsSnapshot,
  }) async {
    debugLog('started reconsciling');
    final Set<String> localIdKeys = Set.from(fsSnapshot.keys)
      ..addAll(dbSnapshot.keys);
    final List<DbChange> changeList = [];

    for (var localId in localIdKeys) {
      //debugLog('processing localId: $localId');
      final fsEntry = fsSnapshot[localId];
      final dbEntry = dbSnapshot[localId];

      switch ((fsEntry, dbEntry)) {
        case ((ExistingFile file, null)):
          changeList.add(
            DbCreate(
              fs: file,
              hash: await hashService.hashFile(file: File(file.path)),
              depth: file.depth,
            ),
          );
          debugLog('path: ${fsEntry!.path} decision: create file');
        case ((ExistingFolder folder, null)):
          changeList.add(DbCreate(fs: folder, hash: null, depth: folder.depth));
          debugLog('path: ${fsEntry!.path} decision: create folder');
        case ((ExistingFile() || ExistingFolder()), DbSnapshotEntry dbFile):
          {
            final fsHash = switch (fsEntry) {
              ExistingFile file => await hashService.hashFile(
                file: File(file.path),
              ),
              _ => null,
            };
            debugLog('local id: ${fsEntry!.localFileId}');
            if ((fsHash != dbFile.hash && fsHash != null) ||
                (dbFile.name != pathService.getName(fsEntry.path)) ||
                (dbFile.parentLocalFileId != fsEntry.parentLocalFileId)) {
              debugLog('path: ${fsEntry.path} decision: update');
              debugLog('    reason: ');
              debugLog(
                'fs: hash: $fsHash, name: ${pathService.getName(fsEntry.path)}, parent id: ${fsEntry.parentLocalFileId} ',
              );
              debugLog(
                'db: hash: ${dbFile.hash}, name: ${dbFile.name} parent id: ${dbFile.parentLocalFileId}',
              );
              changeList.add(
                DbUpdate(
                  fs: fsEntry,
                  file: dbFile,
                  hash: fsHash,
                  depth: fsEntry.depth,
                ),
              );
            }
          }
        case ((null, DbSnapshotEntry file)):
          {
            changeList.add(DbDelete(file: file, depth: 0));
            debugLog('file name: ${file.name} decision: delete');
          }
      }
    }
    return changeList;
  }
}
