import 'package:cross_platform_project/presentation/screens/auth/auth_screen.dart';
import 'package:cross_platform_project/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => Placeholder()),
      GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
      GoRoute(path: '/auth', builder: (context, state) => AuthScreen()),
    ],
  );
});
