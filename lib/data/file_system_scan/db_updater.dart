import 'package:collection/collection.dart';
import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/utility/storage_path_service.dart';
import 'package:cross_platform_project/data/data_source/local/database/dao/files_dao.dart';
import 'package:cross_platform_project/data/file_system_scan/file_system_scanner.dart';
import 'package:cross_platform_project/data/file_system_scan/reconciler.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:uuid/v4.dart';

class DbUpdater {
  DbUpdater({
    required this.filesTable,
    required this.mapper,
    required this.pathService,
  });

  final FilesDao filesTable;
  final FileModelMapper mapper;
  final StoragePathService pathService;

  Future<void> updateDb({required List<DbChange> changeList}) async {
    //Phase 1
    for (var change in changeList) {
      switch (change) {
        case DbCreate():
          debugLog('creating from fs');
          filesTable.insertFile(
            mapper.toInsert(
              FileModel(
                id: UuidV4().generate(),
                ownerId: await pathService.getOwnerIdByPath(
                  path: change.fs.path,
                ),
                parentId: null,
                depth: change.fs.depth,

                name: pathService.getName(change.fs.path),
                mimeType: null,
                isFolder: change.fs is ExistingFolder,
                size: switch (change.fs) {
                  ExistingFile file => file.size,
                  _ => null,
                },
                hash: change.hash,
                syncEnabled: true,
                downloadEnabled: true,
                syncStatus: SyncStatus.creating,
                downloadStatus: DownloadStatus.downloaded,
                createdAt: DateTime.now(),
                updatedAt: switch (change.fs) {
                  ExistingFile file => file.modifiedAt,
                  _ => DateTime.fromMicrosecondsSinceEpoch(0),
                },
                deletedAt: null,
              ),
              change.fs.localFileId,

              tempParentId: change.fs.parentLocalFileId,
            ),
          );
        case DbDelete():
          debugLog('deleting from fs');
          filesTable.updateFile(
            change.file.id,
            mapper.toUpdate(
              mapper
                  .fromDbFile(change.file)
                  .copyWith(syncStatus: SyncStatus.deleted),
            ),
          );
        case DbUpdate():
          debugLog('updating from fs');
          final FileModel currentModel = mapper.fromDbFile(change.file);
          final FileModel updateModel = currentModel.copyWith(
            hash: change.hash,
            size: change.fs is ExistingFile
                ? (change.fs as ExistingFile).size
                : null,
            /* updatedAt: change.fs is ExistingFile
                ? (change.fs as ExistingFile).modifiedAt
                : DateTime.now(), */
            updatedAt: DateTime.now().toUtc(),
            syncStatus: currentModel.syncStatus == SyncStatus.created
                ? SyncStatus.created
                : SyncStatus.updated,
            name: pathService.getName(change.fs.path),
            parentId: change.fs.parentLocalFileId == null
                ? null
                : (await filesTable.getFileByLocalFileId(
                    change.fs.parentLocalFileId!,
                  ))!.id,
            depth: change.fs.depth,
          );

          filesTable.updateFile(updateModel.id, mapper.toUpdate(updateModel));
      }
    }

    //Phase 2 - for entries with tempParent
    final inProgress = await filesTable.getFilesByStatus(SyncStatus.creating);
    //final queue = PriorityQueue((Dbfile arg) => arg.)
    for (var file in inProgress) {
      filesTable.updateFile(
        file.id,
        mapper.toUpdate(
          mapper
              .fromDbFile(file)
              .copyWith(
                parentId: (await filesTable.getFileByLocalFileId(
                  file.tempParentId!,
                ))!.id,
                syncStatus: SyncStatus.created,
              ),
          tempParentId: null,
        ),
      );
    }
  }
}
