import 'package:cross_platform_project/data/providers/providers.dart';
import 'package:cross_platform_project/presentation/providers/auth_view_model_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { authenticated, unauthenticated }

final authStatusProvider = FutureProvider<AuthStatus>((ref) async {
  final authStorage = ref.watch(authDataStorageProvider);

  final authViewModel = ref.watch(authViewModelProvider);
  return (await authStorage.getAccessToken() != null) ||
          (authViewModel.value != null && authViewModel.value!.isAuthorized)
      ? AuthStatus.authenticated
      : AuthStatus.unauthenticated;
});
