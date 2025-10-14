import 'package:ecommerce/feature/auth/presentation/state/auth_bloc.dart';
import 'package:ecommerce/feature/auth/presentation/state/auth_state.dart';
import 'package:ecommerce/feature/auth/presentation/ui/screen/login_page.dart';
import 'package:ecommerce/feature/auth/presentation/ui/screen/start_screen.dart';
import 'package:ecommerce/feature/home/domain/entity/home_entity.dart';
import 'package:ecommerce/feature/home/presentation/ui/screen/button_navigation.dart';
import 'package:ecommerce/feature/home/presentation/ui/screen/detaile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const StartScreen(), // Start screen or login
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/main',
      builder: (context, state) => const BottomNavBar(), // Bottom nav with tabs
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final product = state.extra as HomeEntity;
        return DetailePage(product: product);
      },
    ),
  ],
  redirect: (context, state) {
    final authState = context.read<AuthBloc>().state;
    final isLoggedIn = authState is AuthLogInState;

    // If logged in, redirect login/start to main
    if (isLoggedIn && state.uri.toString() == '/') {
      return '/main';
    }

    // If not logged in, redirect main to login
    if (!isLoggedIn && state.uri.toString() == '/main') {
      return '/';
    }

    return null; // no redirect
  },
);
