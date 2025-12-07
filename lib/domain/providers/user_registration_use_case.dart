import 'package:cross_platform_project/data/providers/providers.dart';
import 'package:cross_platform_project/domain/repositories/auth_repository.dart';
import 'package:cross_platform_project/domain/use_cases/user_registration_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRegistrationUseCaseProvider = Provider<UserRegistrationUseCase>((
  ref,
) {
  final AuthRepository auth = ref.watch(authRepositoryProvider);
  return UserRegistrationUseCase(auth: auth);
});
