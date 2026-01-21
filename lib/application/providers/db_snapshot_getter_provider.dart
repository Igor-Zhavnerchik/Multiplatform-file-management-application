import 'package:cross_platform_project/application/db_snapshot_getter.dart';
import 'package:cross_platform_project/application/providers/current_user_service_provider.dart';
import 'package:cross_platform_project/data/data_source/local/database/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dbSnapshotGetterProvider = Provider<DbSnapshotGetter>((ref) {
  final filesTable = ref.watch(filesTableProvider);
  final userService = ref.watch(currentUserServiceProvider);
  return DbSnapshotGetter(filesTable: filesTable, userService: userService);
});
