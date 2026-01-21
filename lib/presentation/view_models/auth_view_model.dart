import 'dart:async';

import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/domain/providers/sign_out_use_case_provider.dart';
import 'package:cross_platform_project/domain/providers/user_login_use_case_provider.dart';
import 'package:cross_platform_project/domain/providers/user_registration_use_case.dart';

import 'package:cross_platform_project/domain/use_cases/auth_operations/sign_out_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/auth_operations/user_login_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/auth_operations/user_registration_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthViewState {
  final bool isAuthorized;

  AuthViewState({this.isAuthorized = false});

  AuthViewState copyWith({bool? isAuthorized}) {
    return AuthViewState(isAuthorized: isAuthorized ?? this.isAuthorized);
  }
}

class AuthViewModel extends Notifier<AuthViewState> {
  late final UserLoginUseCase _userLoginUseCase;

  late final SignOutUseCase _signOutUseCase;
  late final UserRegistrationUseCase _userRegistrationUseCase;

  @override
  AuthViewState build() {
    _userLoginUseCase = ref.read(userLoginUseCaseProvider);
    _signOutUseCase = ref.read(signOutUseCaseProvider);
    _userRegistrationUseCase = ref.read(userRegistrationUseCaseProvider);

    return AuthViewState();
  }

  Future<Result<void>> tryLogin({
    required String email,
    required String password,
    required bool saveOnThisDevice,
  }) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      return Failure('fields cannot be empty');
    }

    return await _userLoginUseCase(
      email: email,
      password: password,
      saveOnThisDevice: saveOnThisDevice,
    );
  }

  Future<void> signOut() async {
    state = state.copyWith(isAuthorized: false);
    await _signOutUseCase();
  }

  Future<Result<void>> tryRegister({
    required String email,
    required String password,
    required String confirm,
  }) async {
    if (email.trim().isEmpty || password.isEmpty || confirm.isEmpty) {
      return Failure('Fields cannot be empty');
    }
    if (password != confirm) {
      return Failure('Passwords didn\'t match');
    }
    return await _userRegistrationUseCase(email: email, password: password);
  }
}
