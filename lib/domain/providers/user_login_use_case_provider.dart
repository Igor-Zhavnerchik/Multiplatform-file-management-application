import 'package:cross_platform_project/data/repositories/providers/auth_repository_provider.dart';
import 'package:cross_platform_project/domain/use_cases/auth_operations/user_login_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userLoginUseCaseProvider = Provider<UserLoginUseCase>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  return UserLoginUseCase(auth: auth);
});
