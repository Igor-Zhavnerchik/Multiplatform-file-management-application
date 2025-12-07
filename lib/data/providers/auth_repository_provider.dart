import 'package:cross_platform_project/core/providers/supabase_client_provider.dart';
import 'package:cross_platform_project/data/providers/auth_data_storage_provider.dart';
import 'package:cross_platform_project/data/repositories/auth_repository_impl.dart';
import 'package:cross_platform_project/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(authDataStorageProvider);
  final client = ref.watch(supabaseClientProvider);

  return AuthRepositoryImpl(client: client, storage: storage);
});
