import 'dart:async';

import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/application/services/current_user_service.dart';
import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/common/utility/safe_call.dart';
import 'package:cross_platform_project/data/data_source/local/database/dao/users_dao.dart';

class SettingsService {
  final UsersDao usersTable;
  final CurrentUserService userService;

  SettingsService({required this.usersTable, required this.userService});

  bool _defaultContentSyncEnabled = true;

  final _controller = StreamController<bool>.broadcast();
  StreamSubscription<bool>? _subscription;

  bool get defaultContentSyncEnabled => _defaultContentSyncEnabled;

  Stream<bool> get defaultContentSyncEnabledStream => _controller.stream;

  void init() {
    debugLog('started settings init');
    _subscription?.cancel();
    _subscription = null;

    _subscription = usersTable
        .watchDefaultContentSyncOption(userId: userService.currentUserId)
        .listen((value) {
          _defaultContentSyncEnabled = value;
          debugLog('SettingsService emit: $value');
          _controller.add(value);
        });
    debugLog('ended settings init');
  }

  Future<Result<void>> setdefaultContentSyncEnable(bool value) async {
    return await safeCall(() async {
      usersTable.setdefaultContentSyncOption(
        userId: userService.currentUserId,
        isEnabled: value,
      );
    }, source: 'SettingsService.setdefaultContentSyncEnable');
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _controller.close();
  }
}
