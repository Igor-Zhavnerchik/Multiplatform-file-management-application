import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/core/utility/safe_call.dart';
import 'package:cross_platform_project/domain/entities/user_entity.dart';
import 'package:cross_platform_project/domain/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient client;
  final FlutterSecureStorage storage;

  AuthRepositoryImpl({required this.client, required this.storage});

  @override
  UserEntity? getCurrentUser() {
    final user = client.auth.currentUser;

    return user == null ? null : UserEntity(id: user.id, email: user.email);
  }

  @override
  Future<bool> resumeSession() async {
    return await storage.read(key: 'saveOnThisDevice') == 'true';
  }

  @override
  Future<Result<UserEntity>> signIn({
    required String email,
    required String password,
    required bool saveOnThisDevice,
  }) async {
    final AuthResponse response;
    try {
      response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (error) {
      return Failure('error: $error');
    }
    await storage.write(
      key: 'saveOnThisDevice',
      value: saveOnThisDevice ? 'true' : 'false',
    );

    final user = UserEntity(id: response.user!.id, email: response.user!.email);

    return Success(user);
  }

  @override
  Future<void> signOut() async {
    await client.auth.signOut();
    await storage.write(key: 'hasSavedSession', value: 'false');
  }

  @override
  Future<Result<UserEntity>> registerUser({
    required String email,
    required String password,
  }) async {
    return await safeCall(() async {
      final AuthResponse response = await client.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw Exception(
          'failed to register with email : $email password: $password',
        );
      }
      return UserEntity(id: response.user!.id, email: email);
    }, source: 'AuthRepository.registeruser');
  }
}
