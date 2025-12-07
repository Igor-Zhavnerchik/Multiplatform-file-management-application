import 'package:cross_platform_project/data/providers/file_model_mapper_provider.dart';
import 'package:cross_platform_project/data/providers/providers.dart';

import '../data_source/remote/remote_data_source.dart';
import '../data_source/remote/remote_database_data_source.dart';
import '../data_source/remote/remote_storage_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cross_platform_project/core/providers/supabase_client_provider.dart';

final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final auth = ref.watch(authRepositoryProvider);
  final storage = ref.watch(remoteStorageDataSourceProvider);
  final database = ref.watch(remoteDatabaseDataSourceProvider);
  final pathService = ref.watch(storagePathServiceProvider);
  final mapper = ref.watch(fileModelMapperProvider);

  return RemoteDataSource(
    client: client,
    auth: auth,
    storage: storage,
    database: database,
    pathService: pathService,
    mapper: mapper,
  );
});

final remoteStorageDataSourceProvider = Provider<RemoteStorageDataSource>((
  ref,
) {
  final client = ref.watch(supabaseClientProvider);

  return RemoteStorageDataSource(client: client);
});

final remoteDatabaseDataSourceProvider = Provider<RemoteDatabaseDataSource>((
  ref,
) {
  final client = ref.watch(supabaseClientProvider);

  return RemoteDatabaseDataSource(client: client);
});
