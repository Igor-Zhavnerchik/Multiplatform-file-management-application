import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/data/data_source/local/database/dao/files_dao.dart';
import 'package:cross_platform_project/data/file_system_scan/db_updater.dart';
import 'package:cross_platform_project/data/file_system_scan/file_system_scanner.dart';
import 'package:cross_platform_project/data/file_system_scan/reconciler.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';

class FsScanHandler {
  FsScanHandler({
    required this.scanner,
    required this.reconciler,
    required this.updater,
    required this.filesTable,
    required this.mapper,
  });

  final FileSystemScanner scanner;
  final Reconciler reconciler;
  final DbUpdater updater;
  final FilesDao filesTable;
  final FileModelMapper mapper;

  Future<void> executeScan() async {
    debugLog('scanning fs');
    final fsSnapshot = await scanner.scan();
    debugLog('getting files from db');
    final fileList = await filesTable.getAllFiles();
    debugLog('transforming db response to snapshot');
    final dbSnapshot = Map.fromEntries(
      fileList.map((file) => MapEntry(file.localFileId, file)),
    );
    final changes = await reconciler.detectDbChanges(
      dbSnapshot: dbSnapshot,
      fsSnapshot: fsSnapshot,
    );
    
    debugLog('appling changes');
    updater.updateDb(changeList: changes);
  }
}
