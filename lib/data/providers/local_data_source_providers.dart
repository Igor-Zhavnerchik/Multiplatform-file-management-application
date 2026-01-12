import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/providers/current_user_service_provider.dart';
import 'package:cross_platform_project/data/providers/local_storage_provider.dart';
import 'package:cross_platform_project/data/data_source/local/database/database_providers.dart';
import 'package:cross_platform_project/data/data_source/local/local_file_id_service.dart/local_file_id_serivde_provider.dart';
import 'package:cross_platform_project/data/data_source/local/local_data_source.dart';
import 'package:cross_platform_project/core/services/storage_path_service.dart';
import 'package:cross_platform_project/data/models/providers/file_model_mapper_provider.dart';
import 'package:cross_platform_project/data/services/providers/hash_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localDataSourceProvider = Provider.autoDispose<LocalDataSource>((ref) {
  final pathService = ref.watch(storagePathServiceProvider);
  final localStorage = ref.watch(localStorageProvider);
  final filesTable = ref.watch(filesTableProvider);
  final mapper = ref.watch(fileModelMapperProvider);
  final hashService = ref.watch(hashServiceProvider);
  final localFileIdService = ref.watch(localFileIdServiceProvider);
  return LocalDataSource(
    pathService: pathService,
    localStorage: localStorage,
    filesTable: filesTable,
    mapper: mapper,
    hashService: hashService,
    localFileIdService: localFileIdService,
  );
});

final storagePathServiceProvider = Provider<StoragePathService>((ref) {
  ref.onDispose(() => debugLog('PATH SERVICE DISPOSED'));
  final filesTable = ref.watch(filesTableProvider);
  final currentUserService = ref.watch(currentUserServiceProvider);
  return StoragePathService(
    filesTable: filesTable,
    currentUserService: currentUserService,
  );
});
