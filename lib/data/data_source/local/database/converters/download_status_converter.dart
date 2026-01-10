import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:drift/drift.dart';

class DownloadStatusConverter extends TypeConverter<DownloadStatus, String> {
  @override
  String toSql(DownloadStatus value) {
    return value.name;
  }

  @override
  DownloadStatus fromSql(String fromDb) {
    return DownloadStatus.values.firstWhere((status) => status.name == fromDb);
  }
}
