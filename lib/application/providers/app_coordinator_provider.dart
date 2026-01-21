import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/application/providers/app_start_service_provider.dart';
import 'package:cross_platform_project/presentation/providers/router_provider.dart';
import 'package:cross_platform_project/application/providers/auth_status_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appCoordinatorProvider = Provider<void>((ref) {
  final router = ref.watch(routerProvider);
  final appStartService = ref.watch(appStartServiceProvider);

  ref.listen(authStatusProvider, (prev, next) async {
    next.whenData((data) async {
      if (data != prev?.value) {
        debugLog('COORDINATOR: status: ${data.name}');
        if (data == AuthStatus.unauthenticated) {
          debugLog('launching auth');
          router.go('/auth');
        } else {
          debugLog('launching home');
          await appStartService.onUserLogin();
          router.go('/home');
        }
      }
    });
  });
});
