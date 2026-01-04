import 'package:cross_platform_project/presentation/view_models/auth_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthViewState>(
  () => AuthViewModel(),
);
