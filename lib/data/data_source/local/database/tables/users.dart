import 'package:drift/drift.dart';

@DataClassName('DbUser')
class Files extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();

  BoolColumn get defaultSyncEnabled => boolean()();
  BoolColumn get defaultDownloadEnabled => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
