import 'package:cross_platform_project/application/fs_scan/fs_scan_handler.dart';
import 'package:cross_platform_project/application/providers/db_snapshot_getter_provider.dart';
import 'package:cross_platform_project/data/file_system/fs_scanner_providers.dart';
import 'package:cross_platform_project/domain/sync/fs_sync/fs_sync_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fsScanHandlerProvider = Provider.autoDispose<FsScanHandler>((ref) {
  final scanner = ref.watch(fileSystemScannerProvider);
  final reconciler = ref.watch(reconcilerProvider);
  final changeApplier = ref.watch(fsChangeApplierProvider);
  final dbSnapshotGetter = ref.watch(dbSnapshotGetterProvider);
  return FsScanHandler(
    scanner: scanner,
    reconciler: reconciler,
    changeApplier: changeApplier,
    dbSnapshotGetter: dbSnapshotGetter,
  );
});
