import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/providers/supabase_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserIdProvider = StreamProvider.autoDispose<String?>((ref) {
  final client = ref.watch(supabaseClientProvider);

  return client.auth.onAuthStateChange.map((data) {
    final id = data.session?.user.id;
    debugLog('Auth stream emitted new ID: $id');
    return id;
  });
});
