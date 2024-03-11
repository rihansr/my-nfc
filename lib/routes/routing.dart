import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/navigation_service.dart';
import '../routes/routes.dart';
import '../views/login_view.dart';
import '../views/scan_view.dart';

final GoRouter router = GoRouter(
  navigatorKey: navigator.navigatorKey,
  initialLocation: '/${Routes.scan}',
  routes: <RouteBase>[
    GoRoute(
        name: Routes.scan,
        path: '/${Routes.scan}',
        builder: (BuildContext context, GoRouterState state) {
          return const ScanView();
        },
      ),
    GoRoute(
      name: Routes.login,
      path: '/${Routes.login}',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginView();
      },
    ),
    GoRoute(
      path: '/${Routes.login}/:id',
      builder: (BuildContext context, GoRouterState state) {
        return LoginView(params: state.pathParameters);
      },
    ),
  ],
  errorBuilder: (context, state) => const Scaffold(
    body: Center(
      child: Text('Page not found'),
    ),
  ),
);
