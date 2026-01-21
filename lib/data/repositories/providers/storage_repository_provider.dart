import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/application/providers/current_user_service_provider.dart';
import 'package:cross_platform_project/data/models/providers/file_model_mapper_provider.dart';
import 'package:cross_platform_project/data/providers/local_data_source_providers.dart';
import 'package:cross_platform_project/data/providers/remote_data_source_providers.dart';
import 'package:cross_platform_project/data/services/providers/uuid_generation_service_provider.dart';
import 'package:cross_platform_project/data/repositories/storage_repository_impl.dart';
import 'package:cross_platform_project/domain/sync/providers/sync_providers.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cross_platform_project/application/providers/supabase_client_provider.dart';

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  //FIXME somewhere dispose or update that triggers dispose of storage repo
  final client = ref.read(supabaseClientProvider);
  final remoteDataSource = ref.read(remoteDataSourceProvider);
  final localDataSource = ref.read(localDataSourceProvider);
  final syncStatusManager = ref.read(syncStatusManagerProvider);
  final mapper = ref.read(fileModelMapperProvider);
  final uuidService = ref.read(uuidGenerationServiceProvider);
  final currentUserService = ref.read(currentUserServiceProvider);

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
