import 'package:cross_platform_project/data/providers/auth_repository_provider.dart';
import 'package:cross_platform_project/data/services/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProvider = Provider<CurrentUserProvider>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  return CurrentUserProvider(auth: auth);
});
