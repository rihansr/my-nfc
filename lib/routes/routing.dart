import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/navigation_service.dart';
import '../routes/routes.dart';
import '../views/landing_view.dart';
import '../views/scan_view.dart';

final GoRouter router = GoRouter(
  navigatorKey: navigator.navigatorKey,
  initialLocation: '/${Routes.design}',
  routes: <RouteBase>[
    GoRoute(
      name: Routes.scan,
      path: '/${Routes.scan}',
      builder: (BuildContext context, GoRouterState state) {
        return const ScanView();
      },
    ),
    GoRoute(
      name: Routes.design,
      path: '/${Routes.design}',
      builder: (BuildContext context, GoRouterState state) {
        return const LandingView();
      },
    ),
    GoRoute(
      path: '/${Routes.design}/:uid',
      builder: (BuildContext context, GoRouterState state) {
        return LandingView(params: state.pathParameters);
      },
    ),
  ],
  errorBuilder: (context, state) => const Scaffold(
    body: Center(
      child: Text('Page not found'),
    ),
  ),
);
