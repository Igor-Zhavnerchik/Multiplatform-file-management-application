import 'package:cross_platform_project/core/providers/supabase_client_provider.dart';
import 'package:cross_platform_project/data/repositories/auth_repository_impl.dart';
import 'package:cross_platform_project/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final storage = FlutterSecureStorage();
  return AuthRepositoryImpl(client: client, storage: storage);
});
