import 'package:cross_platform_project/core/converters/providers/bytes_to_stream_converter_provider.dart';
import 'package:cross_platform_project/data/providers/current_user_provider.dart';
import 'package:cross_platform_project/data/providers/file_model_mapper_provider.dart';
import 'package:cross_platform_project/data/providers/providers.dart';

import '../data_source/remote/remote_data_source.dart';
import '../data_source/remote/remote_database_data_source.dart';
import '../data_source/remote/remote_storage_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cross_platform_project/core/providers/supabase_client_provider.dart';

final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final storage = ref.watch(remoteStorageDataSourceProvider);
  final database = ref.watch(remoteDatabaseDataSourceProvider);
  final pathService = ref.watch(storagePathServiceProvider);
  final mapper = ref.watch(fileModelMapperProvider);
  final userProvider = ref.watch(currentUserProvider);

  return RemoteDataSource(
    client: client,
    currentUserProvider: userProvider,
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
  final bytesToStreamConverter = ref.watch(bytesToStreamConverterProvider);
  return RemoteStorageDataSource(client: client, bytesToStreamConverter: bytesToStreamConverter);
});

final remoteDatabaseDataSourceProvider = Provider<RemoteDatabaseDataSource>((
  ref,
) {
  final client = ref.watch(supabaseClientProvider);

  return RemoteDatabaseDataSource(client: client);
});
