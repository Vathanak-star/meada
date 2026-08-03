
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Home Screen"),
            ElevatedButton(onPressed: () => context.go('/'), child: const Text('Go to Splash Screen')),
            ElevatedButton(onPressed: () => context.go('login'), child: const Text('Go to Login Screen')),
            ElevatedButton(onPressed: () => context.go('ai_assistant'), child: const Text('Go to AI Assistant')),
            ElevatedButton(onPressed: () => context.go('health_tracking'), child: const Text('Go to Health Tracking')),
            ElevatedButton(onPressed: () => context.go('emergency_support'), child: const Text('Go to emergency_support')),
          ],
        ),
      ),
    );
  }
}
