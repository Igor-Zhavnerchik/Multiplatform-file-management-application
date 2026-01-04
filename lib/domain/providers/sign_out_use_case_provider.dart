import 'package:cross_platform_project/data/providers/providers.dart';
import 'package:cross_platform_project/domain/use_cases/auth_operations/sign_out_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  return SignOutUseCase(auth: auth);
});
