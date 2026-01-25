import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/data/data_source/local/database/app_database.dart';
import 'package:cross_platform_project/data/data_source/local/database/converters/sync_status_converter.dart';
import 'package:cross_platform_project/data/data_source/local/database/tables/files.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:drift/drift.dart';

part 'files_dao.g.dart';

enum TypeFilter { all, onlyFiles, onlyFolders }

enum DeleteFilter { exclude, onlyDeleted, include }

@DriftAccessor(tables: [Files])
class FilesDao extends DatabaseAccessor<AppDatabase> with _$FilesDaoMixin {
  FilesDao(super.db);

  Future<List<DbFile>> selectFiles({
    required String ownerId,
    TypeFilter typeFilter = TypeFilter.all,
    DeleteFilter deleteFilter = DeleteFilter.exclude,
    Set<SyncStatus>? statuses,
  }) {
    debugLog(
      'getting files from db: owner: $ownerId filter: ${typeFilter.name}',
    );
    final query = select(files)
      ..where((files) => files.ownerId.equals(ownerId));

    if (statuses != null) {
      query.where(
        (files) =>
            files.syncStatus.isIn(statuses.map((status) => status.toDb())),
      );
    }

    _applyFilters(
      query: query,
      typeFilter: typeFilter,
      deleteFilter: deleteFilter,
    );

    return query.get();
  }

  Future<List<DbFile>> getAllFiles() {
    return select(files).get();
  }

  //FIXME
  Future<DbFile?> getFile({String? fileId, String? localFileId}) {
    final query = select(files);
    if (fileId != null) {
      query.where((entity) => entity.id.equals(fileId));
    } else if (localFileId != null) {
      query.where((entity) => entity.localFileId.equals(localFileId));
    }
    return query.getSingleOrNull();
  }

  Future insertFile(FilesCompanion entry) => into(files).insert(entry);

  Future deleteFile(String id) {
    return (delete(files)..where((entity) => entity.id.equals(id))).go();
  }

  Future updateFile(String id, FilesCompanion data) {
    return (update(files)..where((entity) => entity.id.equals(id))).write(data);
  }

  Future<void> updateOnlyStatus(String id, SyncStatus status) {
    return (update(files)..where((t) => t.id.equals(id))).write(
      FilesCompanion(syncStatus: Value(status)),
    );
  }

  Stream<List<DbFile>> watchChildren({
    required String? parentId,
    required String ownerId,
    TypeFilter typeFilter = TypeFilter.all,
    DeleteFilter deleteFilter = DeleteFilter.exclude,
  }) {
    final query = select(files);
    query.where(
      (tbl) =>
          tbl.parentId.equalsNullable(parentId) & tbl.ownerId.equals(ownerId),
    );
    _applyFilters(
      query: query,
      typeFilter: typeFilter,
      deleteFilter: deleteFilter,
    );
    return query.watch();
  }

  Future<List<DbFile>> getChildren({
    required String? parentId,
    required String ownerId,
    TypeFilter typeFilter = TypeFilter.all,
    DeleteFilter deleteFilter = DeleteFilter.exclude,
  }) async {
    final query = (select(files)
      ..where(
        (entity) =>
            entity.parentId.equalsNullable(parentId) &
            entity.ownerId.equals(ownerId),
      ));

    _applyFilters(
      query: query,
      typeFilter: typeFilter,
      deleteFilter: deleteFilter,
    );
    return await query.get();
  }

  void _applyFilters({
    required SimpleSelectStatement<Files, DbFile> query,
    required TypeFilter typeFilter,
    required DeleteFilter deleteFilter,
  }) {
    switch (typeFilter) {
      case TypeFilter.onlyFiles:
        query.where((tbl) => tbl.isFolder.equals(false));
      case TypeFilter.onlyFolders:
        query.where((tbl) => tbl.isFolder.equals(true));
      case TypeFilter.all:
        break;
    }

    switch (deleteFilter) {
      case DeleteFilter.exclude:
        query.where(
          (tbl) => tbl.syncStatus.isNotIn({SyncStatus.deleted.toDb()}),
        );

      case DeleteFilter.onlyDeleted:
        query.where((tbl) => tbl.syncStatus.equals(SyncStatus.deleted.toDb()));

      case DeleteFilter.include:
        break;
    }
  }

  //FIXME move to users dao and fix to get primary keys
  Future<List<String?>> getAllUserIds() async {
    final query = selectOnly(files, distinct: true)
      ..addColumns([files.ownerId]);
    final rows = await query.get();
    final userIds = rows.map((row) {
      return row.read(files.ownerId);
    }).toList();
    return userIds;
  }
}

extension SyncStatusSql on SyncStatus {
  String toDb() => SyncStatusConverter().toSql(this);
}
