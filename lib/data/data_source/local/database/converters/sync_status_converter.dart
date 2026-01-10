import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:drift/drift.dart';

class SyncStatusConverter extends TypeConverter<SyncStatus, String> {
  @override
  String toSql(SyncStatus value) {
    return value.name;
  }

  @override
  SyncStatus fromSql(String fromDb) {
    return SyncStatus.values.firstWhere((status) => status.name == fromDb);
  }
}
