import 'dart:async';

import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/services/current_user_service.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/core/utility/safe_call.dart';
import 'package:cross_platform_project/data/data_source/local/database/dao/users_dao.dart';

class SettingsService {
  final UsersDao usersTable;
  final CurrentUserService userService;

  SettingsService({required this.usersTable, required this.userService});

  bool _defaultDownloadEnabled = true;

  final _controller = StreamController<bool>.broadcast();
  StreamSubscription<bool>? _subscription;

  bool get defaultDownloadEnabled => _defaultDownloadEnabled;

  Stream<bool> get defaultDownloadEnabledStream => _controller.stream;

  void init() {
    debugLog('started settings init');
    _subscription?.cancel();
    _subscription = null;

    _subscription = usersTable
        .watchDefaultDownloadOption(userId: userService.currentUserId)
        .listen((value) {
          _defaultDownloadEnabled = value;
          debugLog('SettingsService emit: $value');
          _controller.add(value);
        });
    debugLog('ended settings init');
  }

  Future<Result<void>> setDefaultDownloadEnabled(bool value) async {
    return await safeCall(() async {
      usersTable.setDefaultDownloadOption(
        userId: userService.currentUserId,
        isEnabled: value,
      );
    }, source: 'SettingsService.setDefaultDownloadEnabled');
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _controller.close();
  }
}
