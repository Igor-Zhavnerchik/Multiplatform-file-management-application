import 'dart:io';

import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/data/data_source/local/database/app_database.dart';
import 'package:cross_platform_project/data/file_system_scan/file_system_scanner.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/services/hash_service.dart';

sealed class DbChange {}

class DbUpdate extends DbChange {
  DbUpdate({required this.fs, required this.file, required this.hash});
  final DbFile file;
  final FSEntry fs;
  final String hash;
}

class DbCreate extends DbChange {
  DbCreate({required this.fs, required this.hash});
  final FSEntry fs;
  final String hash;
}

class DbDelete extends DbChange {
  DbDelete({required this.file});
  final DbFile file;
}

class Reconciler {
  Reconciler({required this.hashService});
  final HashService hashService;

  Future<List<DbChange>> detectDbChanges({
    required Map<String, DbFile> dbSnapshot,
    required Map<String, FSEntry> fsSnapshot,
  }) async {
    debugLog('started reconsciling');
    final Set<String> localIdKeys = Set.from(fsSnapshot.keys)
      ..addAll(dbSnapshot.keys);
    final List<DbChange> changeList = [];

    for (var localId in localIdKeys) {
      debugLog('processing localId: $localId');
      final fsEntry = fsSnapshot[localId];
      final dbEntry = dbSnapshot[localId];

      switch ((fsEntry, dbEntry)) {
        case ((ExistingFile file, null)):
          changeList.add(
            DbCreate(
              fs: file,
              hash: await hashService.hashFile(File(file.path)),
            ),
          );
          debugLog('path: ${fsEntry!.path} decision: create file');
        case ((ExistingFolder folder, null)):
          changeList.add(
            DbCreate(
              fs: folder,
              hash: await hashService.hashFolder(Directory(folder.path)),
            ),
          );
          debugLog('path: ${fsEntry!.path} decision: create folder');
        case ((ExistingFile() || ExistingFolder()), DbFile file):
          {
            final fsHash = switch (fsEntry) {
              ExistingFile file => await hashService.hashFile(File(file.path)),
              ExistingFolder folder => await hashService.hashFolder(
                Directory(folder.path),
              ),
              MissingEntry miss => null,
              _ => null,
            };

            if (fsHash != file.hash && fsHash != null) {
              changeList.add(DbUpdate(fs: fsEntry!, file: file, hash: fsHash));
            }
          }
          debugLog('path: ${fsEntry!.path} decision: update');
        case ((null, DbFile file)):
          {
            changeList.add(DbDelete(file: file));
            debugLog('path: ${fsEntry!.path} decision: delete');
          }
      }
    }
    return changeList;
  }
}
