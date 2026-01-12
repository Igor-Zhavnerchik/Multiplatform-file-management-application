import 'package:cross_platform_project/core/services/settings_service.dart';
import 'package:cross_platform_project/core/utility/result.dart';

class SetSettingsUseCase {
  final SettingsService settings;

  SetSettingsUseCase({required this.settings});

  Future<Result<void>> call({required bool defaultDownloadEnabled}) async {
    return await settings.setDefaultDownloadEnabled(defaultDownloadEnabled);
  }
}
