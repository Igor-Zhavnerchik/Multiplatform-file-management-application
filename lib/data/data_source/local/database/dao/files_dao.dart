import 'package:cross_platform_project/data/data_source/local/database/app_database.dart';
import 'package:cross_platform_project/data/data_source/local/database/tables/files.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:drift/drift.dart';

part 'files_dao.g.dart';

@DriftAccessor(tables: [Files])
class FilesDao extends DatabaseAccessor<AppDatabase> with _$FilesDaoMixin {
  FilesDao(super.db);

  Future insertFile(FilesCompanion entry) => into(files).insert(entry);

  Future<List<DbFile>> getFilesByOwner(String ownerId) {
    return (select(
      files,
    )..where((entity) => entity.ownerId.equals(ownerId))).get();
  }

  Future<List<DbFile>> getAllFiles() {
    return select(files).get();
  }

  Future deleteFile(String id) {
    return (delete(files)..where((entity) => entity.id.equals(id))).go();
  }

  Future updateFile(String id, FilesCompanion data) {
    return (update(files)..where((entity) => entity.id.equals(id))).write(data);
  }

  Stream<List<DbFile>> watchChildren(String? parentId, String ownerId) {
    return (select(files)..where(
          (entity) =>
              entity.parentId.equalsNullable(parentId) &
              entity.ownerId.equals(ownerId) &
              entity.deletedAt.isNull(),
        ))
        .watch();
  }

  Stream<List<DbFile>> watchFolders(String? parentId, String ownerId) {
    return (select(files)..where(
          (entity) =>
              entity.parentId.equalsNullable(parentId) &
              entity.isFolder.equals(true) &
              entity.ownerId.equals(ownerId) &
              entity.deletedAt.isNull(),
        ))
        .watch();
  }

  Stream<List<DbFile>> watchFiles(String? parentId, String ownerId) {
    return (select(files)..where(
          (entity) =>
              entity.parentId.equalsNullable(parentId) &
              entity.isFolder.equals(false) &
              entity.ownerId.equals(ownerId) &
              entity.deletedAt.isNull(),
        ))
        .watch();
  }

  Future<String?> getNameById(String id) async {
    final query = select(files)..where((entity) => entity.id.equals(id));
    return (await query.getSingleOrNull())?.name;
  }

  Future<DbFile?> getFileByLocalFileId(String localFileId) async {
    final query = select(files)
      ..where((entity) => entity.localFileId.equals(localFileId));
    return await query.getSingleOrNull();
  }

  Future<String?> getParentIdbyId(String id) async {
    final query = select(files)..where((entity) => entity.id.equals(id));
    final parentId = (await query.getSingleOrNull())?.parentId;
    return parentId;
  }

  Future<List<String?>> getAllUserIds() async {
    final query = selectOnly(files, distinct: true)
      ..addColumns([files.ownerId]);
    final rows = await query.get();
    final userIds = rows.map((row) {
      return row.read(files.ownerId);
    }).toList();
    return userIds;
  }

  Future<List<DbFile>> getFilesByStatus(SyncStatus status) async {
    final query = select(files)
      ..where((entity) => entity.syncStatus.equals(status.name));
    return await query.get();
  }
}
