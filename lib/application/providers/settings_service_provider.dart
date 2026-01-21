import 'package:cross_platform_project/application/providers/current_user_service_provider.dart';
import 'package:cross_platform_project/application/services/settings_service.dart';
import 'package:cross_platform_project/data/data_source/local/database/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsServiceProvider = Provider.autoDispose<SettingsService>((ref) {
  final usersTable = ref.watch(usersTableProvider);
  final userService = ref.watch(currentUserServiceProvider);
  return SettingsService(usersTable: usersTable, userService: userService);
});

final settingsStreamProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(settingsServiceProvider);
  return service.defaultContentSyncEnabledStream;
});
