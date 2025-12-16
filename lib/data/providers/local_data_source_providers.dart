import 'package:cross_platform_project/data/data_source/local/database/database_providers.dart';
import 'package:cross_platform_project/data/data_source/local/local_storage_service.dart';
import 'package:cross_platform_project/data/data_source/local/json_storage.dart';
import 'package:cross_platform_project/data/data_source/local/local_data_source.dart';
import 'package:cross_platform_project/core/utility/storage_path_service.dart';
import 'package:cross_platform_project/data/providers/file_model_mapper_provider.dart';
import 'package:cross_platform_project/data/providers/hash_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  final pathService = ref.watch(storagePathServiceProvider);
  final localStorage = ref.watch(localStorageProvider);
  final jsonStorage = ref.watch(jsonStorageProvider);
  final filesTable = ref.watch(filesTableProvider);
  final mapper = ref.watch(fileModelMapperProvider);
  final hashService = ref.watch(hashServiceProvider);
  return LocalDataSource(
    pathService: pathService,
    localStorage: localStorage,
    jsonStorage: jsonStorage,
    filesTable: filesTable,
    mapper: mapper,
    hashService: hashService,
  );
});

final storagePathServiceProvider = Provider<StoragePathService>(
  (ref) => throw UnimplementedError('override in main'),
);

final localStorageProvider = Provider<LocalStorageService>((ref) {
  final pathService = ref.watch(storagePathServiceProvider);
  return LocalStorageService(pathService: pathService);
});

final jsonStorageProvider = Provider<JsonStorage>((ref) {
  final localStorage = ref.watch(localStorageProvider);
  return JsonStorage(files: localStorage);
});
