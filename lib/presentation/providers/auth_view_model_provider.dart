import 'package:cross_platform_project/presentation/screens/auth/auth_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authViewModelProvider =
    NotifierProvider.autoDispose<AuthViewModel, AuthViewState>(
      () => AuthViewModel(),
    );
