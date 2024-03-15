import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../shared/constants.dart';
import '../shared/shared_prefs.dart';
import '../shared/constants.dart';

enum _AppMode { debug, production }

final appConfig = AppConfig.value;

class AppConfig {
  static AppConfig get value => AppConfig._();
  AppConfig._();
  var appMode = kDebugMode ? _AppMode.debug : _AppMode.production;
  bool isPermissionGranted = false;

  init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Future.wait(
      [
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]),
        sharedPrefs.init(),
      ],
    );
    FlutterNativeSplash.remove();
    await rootBundle
        .loadString("assets/files/default_design.json")
        .then((data) {
      kDefaultDesign = jsonDecode(data);
    });
  }

  Map<String, dynamic> get configs => config[appMode.name]!;

  static const config = {
    "debug": {"base": {}},
    "production": {"base": {}}
  };
}
