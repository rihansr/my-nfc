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