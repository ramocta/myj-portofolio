import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//Import file path
import '../features/splash/splash_screen.dart';
import '../features/auth/view/login_page.dart';
import '../features/auth/view/register_page.dart';
import '../features/home/view/main_view.dart';
import '../../features/project/view/project_from_view.dart';
import '../../features/profile/view/profile_detail_view.dart';

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

      GoRoute(
        path: '/main',
        builder: (context, state) => const MainView(),
      ),

      GoRoute(
        path: '/project/add',
        builder: (context, state) => const ProjectFormView(),
      ),

      GoRoute(
        path: '/profile/detail',
        builder: (context, state) => const ProfileDetailView(),
      ),
    ],
  );
}