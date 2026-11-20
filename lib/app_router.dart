
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:food_store/bloc/auth/auth_bloc.dart';
import 'package:food_store/bloc/profile/profile_bloc.dart';

import 'package:food_store/page/auth/login_page.dart';
import 'package:food_store/page/auth/register_page.dart';

import 'package:food_store/page/dashboard/dashboard_page.dart';
import 'package:food_store/page/dashboard/home_page.dart';
import 'package:food_store/page/dashboard/order_page.dart';
import 'package:food_store/page/dashboard/cart_page.dart';
import 'package:food_store/page/dashboard/profile_page.dart';

class AppRouter {
  late final GoRouter router;
  late final GoRouterRefreshStream _authRefreshStream;

  AppRouter(AuthBloc authBloc) {
    _authRefreshStream = GoRouterRefreshStream(authBloc.stream);

    router = GoRouter(
      initialLocation: '/login',
      refreshListenable: _authRefreshStream,
      redirect: (context, state) {
        final authState = authBloc.state;
        final location = state.matchedLocation;

        final isLoginPage = location == '/login';
        final isRegisterPage = location == '/register';
        final isAuthPage = isLoginPage || isRegisterPage;

        final isDashboardPage = location.startsWith('/dashboard');

        // Tunggu pemeriksaan token selesai.
        if (authState is Initial || authState is Loading) {
          if (isDashboardPage) {
            return '/login';
          }

          return null;
        }

        // Pengguna belum login tidak boleh masuk Dashboard.
        if (authState is Unauthenticated) {
          if (isAuthPage) {
            return null;
          }

          return '/login';
        }

        // Pengguna yang sudah login diarahkan ke Dashboard.
        if (authState is Authenticated && isAuthPage) {
          return '/dashboard/home';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return DashboardPage(child: child);
          },
          routes: [
            GoRoute(
              path: '/dashboard/home',
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: '/dashboard/order',
              builder: (context, state) => const OrderPage(),
            ),
            GoRoute(
              path: '/dashboard/cart',
              builder: (context, state) => const CartPage(),
            ),
            GoRoute(
              path: '/dashboard/profile',
              builder: (context, state) {
                context.read<ProfileBloc>().add(
                      const ProfileEvent.loadProfile(),
                    );

                return const ProfilePage();
              },
            ),
          ],
        ),
      ],
    );
  }
}

// Helper untuk konversi Bloc stream ke Listenable.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
