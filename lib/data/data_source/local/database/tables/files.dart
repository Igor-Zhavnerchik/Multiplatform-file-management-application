import 'package:drift/drift.dart';

@DataClassName('DbFile')
class Files extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get parentId => text().nullable()();
  TextColumn get tempParentId => text().nullable()();
  TextColumn get ownerId => text()();

  IntColumn get depth => integer()();
  TextColumn get localFileId => text()();
  IntColumn get size => integer().nullable()();
  TextColumn get hash => text().nullable()();
  BoolColumn get isFolder => boolean()();
  TextColumn get mimeType => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  TextColumn get syncStatus => text()();
  BoolColumn get syncEnabled => boolean()();
  BoolColumn get downloadEnabled => boolean()();
  TextColumn get downloadStatus => text()();

  @override
  Set<Column> get primaryKey => {id};
}
