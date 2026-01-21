import 'package:cross_platform_project/data/data_source/local/database/converters/download_status_converter.dart';
import 'package:cross_platform_project/data/data_source/local/database/converters/sync_status_converter.dart';
import 'package:drift/drift.dart';

@DataClassName('DbFile')
class Files extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get parentId => text().nullable()();
  TextColumn get ownerId => text()();

  TextColumn get localFileId => text()();
  IntColumn get size => integer().nullable()();
  TextColumn get hash => text().nullable()();
  BoolColumn get isFolder => boolean()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get contentUpdatedAt => dateTime()();

  TextColumn get syncStatus => text().map(SyncStatusConverter())();
  BoolColumn get contentSyncEnabled => boolean()();
  TextColumn get downloadStatus => text().map(DownloadStatusConverter())();

  @override
  Set<Column> get primaryKey => {id};
}
