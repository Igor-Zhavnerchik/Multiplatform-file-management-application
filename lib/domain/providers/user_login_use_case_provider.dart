import 'package:cross_platform_project/data/providers/providers.dart';
import 'package:cross_platform_project/data/providers/storage_repository_provider.dart';
import 'package:cross_platform_project/domain/use_cases/user_login_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userLoginUseCaseProvider = Provider<UserLoginUseCase>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  final storage = ref.watch(storageRepositoryProvider);
  return UserLoginUseCase(auth: auth, storage: storage);
});
