import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/providers/current_user_service_provider.dart';
import 'package:cross_platform_project/data/providers/file_model_mapper_provider.dart';
import 'package:cross_platform_project/data/providers/uuid_generation_service_provider.dart';
import 'package:cross_platform_project/data/repositories/storage_repository_impl.dart';
import 'package:cross_platform_project/data/sync/providers/sync_providers.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import 'package:cross_platform_project/core/providers/supabase_client_provider.dart';

final storageRepositoryProvider = Provider.autoDispose<StorageRepository>((
  ref,
) {
  final client = ref.watch(supabaseClientProvider);
  final remoteDataSource = ref.watch(remoteDataSourceProvider);
  final localDataSource = ref.watch(localDataSourceProvider);
  final syncStatusManager = ref.watch(syncStatusManagerProvider);
  final mapper = ref.watch(fileModelMapperProvider);
  final uuidService = ref.watch(uuidGenerationServiceProvider);
  final currentUserService = ref.watch(currentUserServiceProvider);

  debugLog('creating storage repository');
  final repo = StorageRepositoryImpl(
    client: client,
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    syncStatusManager: syncStatusManager,
    mapper: mapper,
    uuidService: uuidService,
    currentUserService: currentUserService,
  );
  ref.onDispose(() {
    repo.dispose();
  });
  return repo;
});
