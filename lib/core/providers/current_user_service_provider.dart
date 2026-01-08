import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/providers/supabase_client_provider.dart';
import 'package:cross_platform_project/core/services/current_user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserServiceProvider = Provider<CurrentUserService>((ref) {
  ref.onDispose(() => debugLog('DISPOSED CURRENT USER SERVICE'));
  final client = ref.watch(supabaseClientProvider);
  return CurrentUserService(client: client);
});
