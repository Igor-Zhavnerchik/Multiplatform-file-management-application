import 'package:cross_platform_project/presentation/providers/auth_view_model_provider.dart';
import 'package:cross_platform_project/presentation/screens/auth_screen/utility_widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationForm extends ConsumerStatefulWidget {
  const RegistrationForm({super.key});

  @override
  ConsumerState<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends ConsumerState<RegistrationForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? emailErrorMessage;
  String? passwordErrorMessage;
  String? confirmPasswordErrorMessage;
  String? registerErrorMessage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Слушатели для очистки ошибок при вводе
    _emailController.addListener(() => _clearErrors());
    _passwordController.addListener(() => _clearErrors());
    _confirmPasswordController.addListener(() => _clearErrors());
  }

  void _clearErrors() {
    if (emailErrorMessage != null ||
        passwordErrorMessage != null ||
        confirmPasswordErrorMessage != null ||
        registerErrorMessage != null) {
      setState(() {
        emailErrorMessage = null;
        passwordErrorMessage = null;
        confirmPasswordErrorMessage = null;
        registerErrorMessage = null;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() async {
    setState(() => registerErrorMessage = null);

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    setState(() {
      if (email.isEmpty) {
        emailErrorMessage = 'Email is required';
      } else if (!email.contains('@')) {
        emailErrorMessage = 'Enter vaild email';
      }
      if (password.isEmpty) {
        passwordErrorMessage = 'Password is required';
      }
      if (confirm != password) {
        confirmPasswordErrorMessage = 'Passwords do not match';
      }
    });

    if (emailErrorMessage == null &&
        passwordErrorMessage == null &&
        confirmPasswordErrorMessage == null) {
      setState(() => isLoading = true);

      final authVM = ref.read(authViewModelProvider.notifier);
      final result = await authVM.tryRegister(
        email: email,
        password: password,
        confirm: confirm,
      );

      if (!mounted) return;

      result.when(
        success: (_) => {},
        failure: (msg, _, _) => setState(() {
          registerErrorMessage = msg;
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
          Text('Create Account', style: theme.textTheme.headlineSmall),
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
          const SizedBox(height: 16),
          AuthTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            icon: Icons.lock_reset_rounded,
            isPassword: true,
            errorMessage: confirmPasswordErrorMessage,
          ),

          if (registerErrorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                registerErrorMessage!,
                style: TextStyle(color: theme.colorScheme.error, fontSize: 13),
              ),
            ),

          const SizedBox(height: 32),
          FilledButton(
            onPressed: isLoading ? null : _onRegisterPressed,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Register'),
          ),
        ],
      ),
    );
  }
}
