import 'package:cross_platform_project/presentation/screens/auth_screen/main_parts/login_form.dart';
import 'package:cross_platform_project/presentation/screens/auth_screen/main_parts/registration_form.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showLogin = true;

  void toggleMode() => setState(() => showLogin = !showLogin);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: showLogin
                    ? LoginForm(key: const ValueKey('login'))
                    : RegistrationForm(key: const ValueKey('reg')),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: toggleMode,
                child: Text.rich(
                  TextSpan(
                    text: showLogin
                        ? "Don't have an account? "
                        : "Already have an account? ",
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    children: [
                      TextSpan(
                        text: showLogin ? 'Register' : 'Login',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
