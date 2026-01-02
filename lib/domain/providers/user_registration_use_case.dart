import 'package:cross_platform_project/data/providers/providers.dart';
import 'package:cross_platform_project/data/providers/storage_repository_provider.dart';
import 'package:cross_platform_project/domain/repositories/auth_repository.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';
import 'package:cross_platform_project/domain/use_cases/auth_operations/user_registration_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRegistrationUseCaseProvider =
    Provider.autoDispose<UserRegistrationUseCase>((ref) {
      final AuthRepository auth = ref.watch(authRepositoryProvider);
      final StorageRepository storage = ref.watch(storageRepositoryProvider);
      return UserRegistrationUseCase(auth: auth, storage: storage);
    });
