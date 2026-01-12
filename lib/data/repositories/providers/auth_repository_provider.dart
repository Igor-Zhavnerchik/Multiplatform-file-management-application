import 'package:cross_platform_project/core/providers/supabase_client_provider.dart';
import 'package:cross_platform_project/data/data_source/local/database/database_providers.dart';
import 'package:cross_platform_project/data/repositories/auth_repository_impl.dart';
import 'package:cross_platform_project/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final storage = FlutterSecureStorage();
  final usersTable = ref.watch(usersTableProvider);
  return AuthRepositoryImpl(
    client: client,
    storage: storage,
    usersTable: usersTable,
  );
});
