import 'package:flutter/material.dart';

final navigator = NavigationService.value;

class NavigationService {
  static NavigationService get value => NavigationService._();
  NavigationService._();

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get context => navigatorKey.currentContext!;
}

/// Extension methods for [BuildContext] to simplify navigation.
extension NavigatorExtension on BuildContext? {
  /// Returns the [NavigatorState] associated with the [BuildContext].
  NavigatorState get navigator => Navigator.of(this ?? navigator.context);

  /// Pops the current route off the navigator and returns [arguments] to the previous route.
  pop({Object? arguments}) => navigator.pop(arguments);

  /// Pops the navigator until the route with the given [route] is at the top.
  popUntil(String route) => navigator.popUntil(ModalRoute.withName(route));

  /// CanPop
  canPop() => navigator.canPop();

  /// Pops the current route off the navigator and pushes a named route onto the navigator.
  popAndPush(String route, {Object? arguments}) =>
    navigator.popAndPushNamed(route, arguments: arguments);

  /// Pushes the named route onto the navigator.
  push(String route, {Object? arguments}) =>
    navigator.pushNamed(route, arguments: arguments);

  /// Pushes the named route onto the navigator and removes all the previous routes until the route with the given [route] is at the top.
  pushUntil(String route, {String? from, Object? arguments}) =>
    navigator.pushNamedAndRemoveUntil(
      route, from == null ? (route) => false : ModalRoute.withName(route));

  /// Replaces the current route of the navigator with the named route.
  pushReplacement(String route, {Object? arguments}) =>
    navigator.pushReplacementNamed(route, arguments: arguments);
}
