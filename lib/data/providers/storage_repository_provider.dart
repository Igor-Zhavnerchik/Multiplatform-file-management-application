import 'package:cross_platform_project/data/providers/file_model_mapper_provider.dart';
import 'package:cross_platform_project/data/repositories/storage_repository_impl.dart';
import 'package:cross_platform_project/data/sync/providers/sync_providers.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import 'package:cross_platform_project/core/providers/supabase_client_provider.dart';

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final remoteDataSource = ref.watch(remoteDataSourceProvider);
  final localDataSource = ref.watch(localDataSourceProvider);
  final auth = ref.watch(authRepositoryProvider);
  final syncProcessor = ref.watch(syncProcessorProvider);
  final syncStatusManager = ref.watch(syncStatusManagerProvider);
  final mapper = ref.watch(fileModelMapperProvider);

  return StorageRepositoryImpl(
    client: client,
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    auth: auth,
    syncProcessor: syncProcessor,
    syncStatusManager: syncStatusManager,
    mapper: mapper,
  );
});
