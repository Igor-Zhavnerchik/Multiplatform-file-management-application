import 'package:flutter/material.dart';

class FlutterSplashScreen extends StatelessWidget {
  const FlutterSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: FlutterLogo(size: 120)));
  }
}
