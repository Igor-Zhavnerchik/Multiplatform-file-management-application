import 'dart:async';

import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/domain/providers/sign_out_use_case_provider.dart';
import 'package:cross_platform_project/domain/providers/user_login_use_case_provider.dart';
import 'package:cross_platform_project/domain/providers/user_registration_use_case.dart';

import 'package:cross_platform_project/domain/use_cases/sign_out_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/user_login_use_case.dart';
import 'package:cross_platform_project/domain/use_cases/user_registration_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ErrorMessage {
  noError(null),
  emptyFieldError('Fields can\'t be empty'),
  invalidPasswordOrEmailError('Invalid email or password'),
  failedLoginError('An error occured in login'),

  differentPasswordsError('Passwords should match'),
  failedRegisterError('An error occured in registration');

  final String? errorMessage;

  const ErrorMessage(this.errorMessage);
}

class AuthViewState {
  final String email;
  final String password;
  final String confirmPassword;
  final bool saveOnThisDevice;
  final bool hasError;
  final ErrorMessage errorMessage;
  final bool isAuthorized;

  AuthViewState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.saveOnThisDevice = false,
    this.hasError = false,
    this.errorMessage = ErrorMessage.noError,
    this.isAuthorized = false,
  });

  AuthViewState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    bool? saveOnThisDevice,
    bool? hasError,
    ErrorMessage? errorMessage,
    bool? isAuthorized,
  }) {
    return AuthViewState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      saveOnThisDevice: saveOnThisDevice ?? this.saveOnThisDevice,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      isAuthorized: isAuthorized ?? this.isAuthorized,
    );
  }
}

class AuthViewModel extends AsyncNotifier<AuthViewState> {
  late final UserLoginUseCase _userLoginUseCase;

  late final SignOutUseCase _signOutUseCase;
  late final UserRegistrationUseCase _userRegistrationUseCase;

  @override
  Future<AuthViewState> build() async {
    _userLoginUseCase = ref.read(userLoginUseCaseProvider);
    _signOutUseCase = ref.read(signOutUseCaseProvider);
    _userRegistrationUseCase = ref.read(userRegistrationUseCaseProvider);

    return AuthViewState();
  }

  void setPassword(String password) {
    state = state.whenData((current) => current.copyWith(password: password));
  }

  void setConfirmPassword(String confirmPassword) {
    state = state.whenData(
      (current) => current.copyWith(confirmPassword: confirmPassword),
    );
  }

  void setEmail(String email) {
    state = state.whenData((current) => current.copyWith(email: email));
  }

  void setSaveOnThisDevice(bool save) {
    state = state.whenData(
      (current) => current.copyWith(saveOnThisDevice: save),
    );
  }

  Future<void> tryLogin() async {
    var currentState = state.value!;
    if (currentState.email.isEmpty || currentState.password.isEmpty) {
      state = AsyncData(
        currentState.copyWith(
          hasError: true,
          errorMessage: ErrorMessage.emptyFieldError,
        ),
      );
      return;
    }

    var successfulLogin = await _userLoginUseCase(
      email: currentState.email,
      password: currentState.password,
      saveOnThisDevice: currentState.saveOnThisDevice,
    );
    if (successfulLogin) {
      state = AsyncData(
        currentState.copyWith(hasError: false, isAuthorized: true),
      );
    } else {
      if (successfulLogin) {
        state = AsyncData(
          currentState.copyWith(
            hasError: true,
            errorMessage: ErrorMessage.invalidPasswordOrEmailError,
            isAuthorized: false,
          ),
        );
      }
    }
  }

  Future<void> signOut() async {
    await _signOutUseCase();
    state = AsyncData(state.value!.copyWith(isAuthorized: false));
  }

  Future<void> tryRegister() async {
    var currentState = state.value!;
    if (currentState.password == currentState.confirmPassword) {
      var successfulRegister = await _userRegistrationUseCase(
        email: currentState.email,
        password: currentState.password,
      );

      if (successfulRegister) {
        tryLogin();
      } else {
        debugLog('failed to register');
      }
    } else {
      state = AsyncData(
        state.value!.copyWith(
          hasError: true,
          errorMessage: ErrorMessage.differentPasswordsError,
        ),
      );
    }
  }
}
