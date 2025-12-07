import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/domain/entities/user_entity.dart';
import 'package:cross_platform_project/domain/repositories/auth_repository.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cross_platform_project/data/data_source/auth_data_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient client;
  final AuthDataStorage storage;

  AuthRepositoryImpl({required this.client, required this.storage});

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = client.auth.currentUser;

    return user == null ? null : UserEntity(id: user.id, email: user.email);
  }

  @override
  Future<bool> signIn({
    required String email,
    required String password,
    required bool saveOnThisDevice,
  }) async {
    final AuthResponse response;
    if (await getCurrentUser() == null) {
      try {
        response = await client.auth.signInWithPassword(
          email: email,
          password: password,
        );
      } on AuthException catch (_) {
        return false;
      }

      if (saveOnThisDevice) {
        await storage.saveTokens(
          accessToken: response.session!.accessToken,
          refreshToken: response.session!.refreshToken,
        );
      }
    }

    return true;
  }

  @override
  Future<void> signOut() async {
    await client.auth.signOut();
    await storage.clearTokens();
  }

  @override
  Future<bool> registerUser({
    required String email,
    required String password,
  }) async {
    final AuthResponse response;

    try {
      response = await client.auth.signUp(email: email, password: password);
    } catch (e) {
      debugLog('AuthRepository: failed to regester user\nerror: $e');
      return false;
    }
    return response.session != null;
  }
}
