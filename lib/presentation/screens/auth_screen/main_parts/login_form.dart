import 'package:cross_platform_project/presentation/providers/auth_view_model_provider.dart';
import 'package:cross_platform_project/presentation/screens/auth_screen/utility_widgets/auth_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool saveOnThisDevice = false;
  String? passwordErrorMessage;
  String? emailErrorMessage;
  String? loginErrorMessage;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      if (emailErrorMessage != null || loginErrorMessage != null) {
        setState(() {
          emailErrorMessage = null;
          loginErrorMessage = null;
        });
      }
    });

    _passwordController.addListener(() {
      if (passwordErrorMessage != null || loginErrorMessage != null) {
        setState(() {
          passwordErrorMessage = null;
          loginErrorMessage = null;
        });
      }
    });
  }

  void _onLoginPressed() async {
    setState(() {
      loginErrorMessage = null;
      if (_emailController.text.trim().isEmpty) {
        emailErrorMessage = 'Email is required';
      } else if (!_emailController.text.contains('@')) {
        emailErrorMessage = 'Enter valid email';
      }
      if (_passwordController.text.isEmpty) {
        passwordErrorMessage = 'Password is required';
      }
    });
    if (passwordErrorMessage == null && emailErrorMessage == null) {
      isLoading = true;
      final authVM = ref.read(authViewModelProvider.notifier);
      final result = await authVM.tryLogin(
        email: _emailController.text,
        password: _passwordController.text,
        saveOnThisDevice: saveOnThisDevice,
      );
      if (!mounted) return;
      result.when(
        success: (_) => {},
        failure: (msg, _, _) => setState(() {
          loginErrorMessage = msg;
          isLoading = false;
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Login', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 24),
          AuthTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            errorMessage: emailErrorMessage,
          ),
          const SizedBox(height: 16),
          AuthTextField(
            controller: _passwordController,
            label: 'Password',
            icon: Icons.lock_outline,
            isPassword: true,
            errorMessage: passwordErrorMessage,
          ),
          if (loginErrorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                loginErrorMessage!,
                style: TextStyle(color: theme.colorScheme.error, fontSize: 13),
              ),
            ),

          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: saveOnThisDevice,
                onChanged: (v) => setState(() {
                  saveOnThisDevice = v!;
                }),
              ),
              const Text('Remember me'),
            ],
          ),
          const SizedBox(height: 24),

          FilledButton(
            onPressed: isLoading ? null : () => _onLoginPressed(),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
