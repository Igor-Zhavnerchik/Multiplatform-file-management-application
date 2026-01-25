import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/application/providers/supabase_client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserIdProvider = StreamProvider<String?>((ref) {
  final client = ref.watch(supabaseClientProvider);

  return client.auth.onAuthStateChange.map((data) {
    final id = data.session?.user.id;
    debugLog('Auth stream emitted new ID: $id');
    return id;
  });
});
