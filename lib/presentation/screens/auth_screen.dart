import 'package:cross_platform_project/domain/providers/user_login_use_case_provider.dart';
import 'package:cross_platform_project/presentation/providers/auth_view_model_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class AuthScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool showLogin = true;

  void regLogToggle() {
    setState(() {
      showLogin = !showLogin;
    });
  }
  /* 
  bool _called = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_called) return;
    _called = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loginVM = ref.read(authViewModelProvider.notifier);
      loginVM.setEmail('ftb2196im@gmail.com');
      loginVM.setPassword('123456');
      loginVM.setSaveOnThisDevice(false);
      await loginVM.tryLogin();
    });
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showLogin ? LoginForm() : RegistrationForm(),
            RichText(
              text: TextSpan(
                text: showLogin
                    ? 'Don\'t have an account? '
                    : 'Already have an account? ',
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: showLogin ? 'Register' : 'Login',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => regLogToggle(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SizedBox(
        width: 400,
        height: 300,
        child: Column(
          children: [
            AuthTextField(
              label: 'Email: ',
              setAuthValue: (value) =>
                  ref.read(authViewModelProvider.notifier).setEmail(value),
            ),
            AuthTextField(
              label: 'Password: ',
              setAuthValue: (value) =>
                  ref.read(authViewModelProvider.notifier).setPassword(value),
            ),
            SaveLoginCheckBox(),
            ElevatedButton(
              onPressed: () =>
                  ref.read(authViewModelProvider.notifier).tryLogin(),
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SizedBox(
        width: 400,
        height: 300,
        child: Column(
          children: [
            AuthTextField(
              label: 'Email: ',
              setAuthValue: (value) =>
                  ref.read(authViewModelProvider.notifier).setEmail(value),
            ),
            AuthTextField(
              label: 'Password: ',
              setAuthValue: (value) =>
                  ref.read(authViewModelProvider.notifier).setPassword(value),
            ),
            AuthTextField(
              label: 'Confirm Password: ',
              setAuthValue: (value) => ref
                  .read(authViewModelProvider.notifier)
                  .setConfirmPassword(value),
            ),

            ElevatedButton(
              onPressed: () =>
                  ref.read(authViewModelProvider.notifier).tryRegister(),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class SaveLoginCheckBox extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool saveOnThisDevice = ref.watch(authViewModelProvider).saveOnThisDevice;
    return Row(
      children: [
        Text('Remember Me '),
        Checkbox(
          value: saveOnThisDevice,
          onChanged: (value) {
            ref
                .read(authViewModelProvider.notifier)
                .setSaveOnThisDevice(value!);
          },
        ),
      ],
    );
  }
}

class AuthTextField extends ConsumerWidget {
  final String label;
  final Function setAuthValue;
  AuthTextField({required this.label, required this.setAuthValue});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      onChanged: (value) => setAuthValue(value),
      decoration: InputDecoration(labelText: label),
    );
  }
}
