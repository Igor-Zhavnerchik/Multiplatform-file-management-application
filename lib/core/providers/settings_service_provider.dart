import 'package:cross_platform_project/core/services/settings_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService();
});
