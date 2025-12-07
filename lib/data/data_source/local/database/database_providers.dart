import 'package:cross_platform_project/data/data_source/local/database/app_database.dart';
import 'package:cross_platform_project/data/data_source/local/database/dao/files_dao.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('override in main'),
);

final filesTableProvider = Provider<FilesDao>(
  (ref) => throw UnimplementedError('override in main'),
);
