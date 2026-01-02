import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/providers/app_start_service_provider.dart';
import 'package:cross_platform_project/core/providers/router_provider.dart';
import 'package:cross_platform_project/core/providers/auth_status_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appCoordinatorProvider = Provider<void>((ref) {
  final router = ref.watch(routerProvider);
  final appStartService = ref.watch(appStartServiceProvider);

  ref.listen(authStatusProvider, (_, next) async {
    next.whenData((data) async {
      if (data == AuthStatus.unauthenticated) {
        debugLog('launching auth');
        router.go('/auth');
      } else {
        debugLog('launching home');
        await appStartService.onUserLogin();
        router.go('/home');
      }
    });
  });
});
