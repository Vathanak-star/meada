import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meada_app/View/screen_feature/ai_assistant.dart';
import 'package:meada_app/View/screen_feature/emergency_support.dart';
import 'package:meada_app/View/screen_feature/health_tracking.dart';

import 'View/home_screen.dart';
import 'View/login_screen.dart';
import 'View/register_screen.dart';
import 'View/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: 'register',
          builder: (BuildContext context, GoRouterState state) {
            return const RegisterScreen();
          },
          routes:  <RouteBase>[
          ]
        ),
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: 'ai_assistant',
          builder: (BuildContext context, GoRouterState state) {
            return const AiAssistant();
          },
        ),
        GoRoute(
          path: 'health_tracking',
          builder: (BuildContext context, GoRouterState state) {
            return const HealthTracking();
          },
        ),
        GoRoute(
          path: 'emergency_support',
          builder: (BuildContext context, GoRouterState state) {
            return const EmergencySupport();
          },
        ),
      ],
    ),
  ],
);
