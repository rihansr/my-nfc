import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/navigation_service.dart';
import '../routes/routes.dart';
import '../views/auth/forget_pass_view.dart';
import '../views/auth/reset_pass_view.dart';
import '../views/auth/sign_in_view.dart';
import '../views/auth/sign_up_view.dart';
import '../views/init/claim_page_view.dart';
import '../views/landing_view.dart';
import '../views/preview.dart';
import '../views/init/scan_view.dart';

final GoRouter router = GoRouter(
  navigatorKey: navigator.navigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return kIsWeb ? const ClaimPageView() : const ScanView();
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
        return SignUpView(uid: state.uri.queryParameters['username']);
      },
    ),
    GoRoute(
      name: Routes.forgetPass,
      path: '/${Routes.forgetPass}',
      builder: (BuildContext context, GoRouterState state) {
        return const ForgetPassView();
      },
    ),
    GoRoute(
      name: Routes.resetPass,
      path: '/${Routes.resetPass}',
      builder: (BuildContext context, GoRouterState state) {
        return ResetPassView(params: state.uri.queryParameters);
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
      path: '/:username',
      builder: (BuildContext context, GoRouterState state) {
        return Preview(uid: state.pathParameters['username']);
      },
    ),
    GoRoute(
      name: Routes.design,
      path: '/${Routes.design}/:username',
      builder: (BuildContext context, GoRouterState state) {
        return LandingView(uid: state.pathParameters['username']);
      },
    ),
  ],
  errorBuilder: (context, state) => const Scaffold(
    body: Center(
      child: Text('Page not found'),
    ),
  ),
);
