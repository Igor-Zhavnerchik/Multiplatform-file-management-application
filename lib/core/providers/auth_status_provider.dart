import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/providers/supabase_client_provider.dart';
import 'package:cross_platform_project/data/repositories/providers/auth_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { authenticated, unauthenticated }

final authStatusProvider = StreamProvider<AuthStatus>((ref) async* {
  final client = ref.watch(supabaseClientProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  bool firstEmit = true;

  debugLog('  Checking auth status in authStatusProvider');

  await for (final event in client.auth.onAuthStateChange) {
    final session = event.session;
    if (firstEmit) {
      debugLog('checking on first emit');
      debugLog('resume session: ${await authRepository.resumeSession()}');
      yield (await authRepository.resumeSession() && session != null)
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;
      firstEmit = false;
    } else if (session != null) {
      {
        debugLog('  User is authenticated');
        yield AuthStatus.authenticated;
      }
    } else {
      debugLog('  User is unauthenticated');
      yield AuthStatus.unauthenticated;
    }
  }
});
