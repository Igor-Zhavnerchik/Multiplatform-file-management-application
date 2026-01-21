import 'package:cross_platform_project/application/providers/settings_service_provider.dart';
import 'package:cross_platform_project/data/models/providers/file_model_mapper_provider.dart';
import 'package:cross_platform_project/data/providers/local_data_source_providers.dart';
import 'package:cross_platform_project/data/repositories/providers/storage_repository_provider.dart';
import 'package:cross_platform_project/data/services/providers/hash_service_provider.dart';
import 'package:cross_platform_project/domain/sync/fs_sync/fs_change_applier.dart';
import 'package:cross_platform_project/domain/sync/fs_sync/reconciler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reconcilerProvider = Provider.autoDispose<Reconciler>((ref) {
  final hashService = ref.watch(hashServiceProvider);
  final pathService = ref.watch(storagePathServiceProvider);
  final localDataSource = ref.watch(localDataSourceProvider);
  return Reconciler(
    hashService: hashService,
    pathService: pathService,
    localDataSource: localDataSource,
  );
});
final fsChangeApplierProvider = Provider.autoDispose<FsChangeApplier>((ref) {
  final pathService = ref.watch(storagePathServiceProvider);
  final localDataSource = ref.watch(localDataSourceProvider);
  final mapper = ref.watch(fileModelMapperProvider);
  final storage = ref.watch(storageRepositoryProvider);
  final settings = ref.watch(settingsServiceProvider);
  return FsChangeApplier(
    localDataSource: localDataSource,
    mapper: mapper,
    pathService: pathService,
    storage: storage,
    settings: settings,
  );
});
