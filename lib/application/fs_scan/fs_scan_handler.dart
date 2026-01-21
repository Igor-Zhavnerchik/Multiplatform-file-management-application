import 'package:cross_platform_project/application/db_snapshot_getter.dart';
import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/domain/sync/fs_sync/fs_change_applier.dart';
import 'package:cross_platform_project/data/file_system/file_system_scanner.dart';
import 'package:cross_platform_project/domain/sync/fs_sync/reconciler.dart';

class FsScanHandler {
  FsScanHandler({
    required this.scanner,
    required this.reconciler,
    required this.changeApplier,
    required this.dbSnapshotGetter,
  });

  final FileSystemScanner scanner;
  final Reconciler reconciler;
  final FsChangeApplier changeApplier;
  final DbSnapshotGetter dbSnapshotGetter;

  Future<void> executeScan() async {
    debugLog('scanning fs');
    final fsSnapshot = await scanner.scan();
    debugLog('getting files from db');
    final dbSnapshot = await dbSnapshotGetter.getDbSnapshot();

    final changes = await reconciler.detectDbChanges(
      dbSnapshot: dbSnapshot,
      fsSnapshot: fsSnapshot,
    );

    debugLog('appling changes');
    changeApplier.apply(changeList: changes);
  }
}
