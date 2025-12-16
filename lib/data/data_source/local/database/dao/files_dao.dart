import 'package:cross_platform_project/data/data_source/local/database/app_database.dart';
import 'package:cross_platform_project/data/data_source/local/database/tables/files.dart';
import 'package:drift/drift.dart';

part 'files_dao.g.dart';

@DriftAccessor(tables: [Files])
class FilesDao extends DatabaseAccessor<AppDatabase> with _$FilesDaoMixin {
  FilesDao(super.db);

  Future insertFile(FilesCompanion entry) => into(files).insert(entry);

  Future<List<DbFile>> getFiles(String ownerId) {
    return (select(
      files,
    )..where((entity) => entity.ownerId.equals(ownerId))).get();
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

  Future<DbFile?> getFileByRelativePath(String relPath) async {
    final query = select(files)
      ..where((entity) => entity.relativePath.equals(relPath));
    return (await query.getSingleOrNull());
  }

  Future<String?> getParentIdbyId(String id) async {
    final query = select(files)..where((entity) => entity.id.equals(id));
    final parentId = (await query.getSingleOrNull())?.parentId;
    return parentId;
  }
}
