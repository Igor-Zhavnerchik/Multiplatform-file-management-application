import 'package:cross_platform_project/data/file_system_scan/fs_scan_handler.dart';
import 'package:cross_platform_project/data/file_system_scan/fs_scanner_providers.dart';
import 'package:cross_platform_project/data/providers/providers.dart';
import 'package:cross_platform_project/data/providers/storage_repository_provider.dart';
import 'package:cross_platform_project/domain/use_cases/user_login_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userLoginUseCaseProvider = Provider<UserLoginUseCase>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  final storage = ref.watch(storageRepositoryProvider);
  final scanHandler = ref.watch(fsScanHandlerProvider);
  final pathService = ref.watch(storagePathServiceProvider);
  return UserLoginUseCase(
    auth: auth,
    storage: storage,
    fsScanHandler: scanHandler,
    pathService: pathService,
  );
});
