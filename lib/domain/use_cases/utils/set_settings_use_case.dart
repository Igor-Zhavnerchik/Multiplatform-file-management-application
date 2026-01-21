import 'package:cross_platform_project/application/services/settings_service.dart';
import 'package:cross_platform_project/common/utility/result.dart';

class SetSettingsUseCase {
  final SettingsService settings;

  SetSettingsUseCase({required this.settings});

  Future<Result<void>> call({required bool defaultDownloadEnabled}) async {
    return await settings.setdefaultContentSyncEnable(defaultDownloadEnabled);
  }
}
