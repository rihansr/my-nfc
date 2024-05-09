import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/navigation_service.dart';
import '../routes/routes.dart';
import '../views/auth/sign_in_view.dart';
import '../views/auth/sign_up_view.dart';
import '../views/init/claim_page_view.dart';
import '../views/landing_view.dart';
import '../views/preview.dart';
import '../views/init/scan_view.dart';

final GoRouter router = GoRouter(
  navigatorKey: navigator.navigatorKey,
  initialLocation: kIsWeb ? '/${Routes.design}/rxrsr' : '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        //return kIsWeb ? const ClaimPageView() : const ScanView();
        return const ClaimPageView();
      },
    ),
    GoRoute(
      name: Routes.signIn,
      path: '/${Routes.signIn}',
      builder: (BuildContext context, GoRouterState state) {
        return const SignInView();
      },
    ),
    GoRoute(
      name: Routes.signUp,
      path: '/${Routes.signUp}',
      builder: (BuildContext context, GoRouterState state) {
        return SignUpView(uid: state.uri.queryParameters['uid']);
      },
    ),
    GoRoute(
      name: Routes.preview,
      path: '/${Routes.preview}',
      builder: (BuildContext context, GoRouterState state) {
        return const Preview();
      },
    ),
    GoRoute(
      path: '/:uid',
      builder: (BuildContext context, GoRouterState state) {
        return Preview(uid: state.pathParameters['uid']);
      },
    ),
    GoRoute(
      name: Routes.design,
      path: '/${Routes.design}/:uid',
      builder: (BuildContext context, GoRouterState state) {
        return LandingView(uid: state.pathParameters['uid']);
      },
    ),
  ],
  errorBuilder: (context, state) => const Scaffold(
    body: Center(
      child: Text('Page not found'),
    ),
  ),
);
