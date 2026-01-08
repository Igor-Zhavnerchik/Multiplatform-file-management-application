import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/services/app_start_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appStartServiceProvider = Provider<AppStartService>((ref) {
  debugLog('reading appStartServiceprovider');
  debugLog('returning service');
  return AppStartService(ref: ref);
});
