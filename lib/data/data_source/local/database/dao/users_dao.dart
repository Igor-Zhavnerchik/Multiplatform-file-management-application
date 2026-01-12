import 'package:cross_platform_project/data/data_source/local/database/app_database.dart';
import 'package:cross_platform_project/data/data_source/local/database/tables/users.dart';
import 'package:drift/drift.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  Future insertUser({required String userId, required String email}) =>
      into(users).insert(
        UsersCompanion.insert(
          id: userId,
          email: email,
          defaultDownloadEnabled: true,
        ),
      );

  Future setDefaultDownloadOption({
    required String userId,
    required bool isEnabled,
  }) async {
    return update(users)
      ..where((tbl) => tbl.id.equals(userId))
      ..write(UsersCompanion(defaultDownloadEnabled: Value(isEnabled)));
  }

  Future<bool> getDefaultDownloadOption({required String userId}) async {
    return (await (select(users)
              ..where((tbl) => tbl.id.equals(userId))
              ..getSingle())
            .getSingle())
        .defaultDownloadEnabled;
  }

  Stream<bool> watchDefaultDownloadOption({required String userId}) {
    return (select(users)..where((tbl) => tbl.id.equals(userId)))
        .watchSingle()
        .map((row) => row.defaultDownloadEnabled);
  }

  Future<DbUser?> getuser({required String userId}) async {
    return await (select(
      users,
    )..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();
  }
}
