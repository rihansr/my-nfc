import 'package:flutter/material.dart';

final navigator = _NavigationService.value;

class _NavigationService {
  static _NavigationService get value => _NavigationService._();
  _NavigationService._();

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get context => navigatorKey.currentContext!;
}