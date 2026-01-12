import 'dart:io';
import 'package:cross_platform_project/data/data_source/local/database/converters/download_status_converter.dart';
import 'package:cross_platform_project/data/data_source/local/database/converters/sync_status_converter.dart';
import 'package:cross_platform_project/data/data_source/local/database/dao/files_dao.dart';
import 'package:cross_platform_project/data/data_source/local/database/dao/users_dao.dart';
import 'package:cross_platform_project/data/data_source/local/database/tables/users.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'tables/files.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DriftDatabase(tables: [Files, Users], daos: [FilesDao, UsersDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'local.db'));
    return NativeDatabase(file);
  });
}
