import 'package:drift/drift.dart';

@DataClassName('DbUser')
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();

  BoolColumn get defaultContentSync => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
