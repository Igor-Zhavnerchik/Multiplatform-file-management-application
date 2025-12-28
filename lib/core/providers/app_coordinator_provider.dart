import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/providers/app_start_service_provider.dart';
import 'package:cross_platform_project/core/providers/router_provider.dart';
import 'package:cross_platform_project/presentation/providers/auth_status_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appCoordinatorProvider = Provider<void>((ref) {
  final router = ref.watch(routerProvider);
  final appStartService = ref.watch(appStartServiceProvider);

  ref.listen(authStatusProvider, (_, next) {
    if (next.value! == AuthStatus.unauthenticated) {
      router.go('/auth');
    }
  });

  ref.listen(authStatusProvider, (_, next) async {
    if (next.value! == AuthStatus.authenticated) {
      await appStartService.onUserLogin();
      router.go('/home');
    }
  });
});
