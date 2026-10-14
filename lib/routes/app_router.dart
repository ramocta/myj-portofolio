import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//Import file path
import '../features/splash/splash_screen.dart';
import '../features/auth/view/login_page.dart';
import '../features/auth/view/register_page.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    initialLocation: '/splash',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginView(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterView(),
      ),
    ],
  );
}