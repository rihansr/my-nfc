import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../shared/constants.dart';
import '../shared/shared_prefs.dart';

enum _AppMode { debug, production }

final appConfig = AppConfig.value;

class AppConfig {
  static AppConfig get value => AppConfig._();
  AppConfig._();
  var appMode = kDebugMode ? _AppMode.debug : _AppMode.production;
  bool isPermissionGranted = false;

  init() async {
    WidgetsFlutterBinding.ensureInitialized();
    if(kIsWeb) usePathUrlStrategy();

    await Future.wait(
      [
        // SystemChrome.setPreferredOrientations([
        //   DeviceOrientation.portraitUp,
        //   DeviceOrientation.portraitDown,
        // ]),
        rootBundle
            .loadString("assets/files/default_design.json")
            .then((data) => kDefaultDesign = jsonDecode(data)),
        rootBundle.loadString("assets/files/additional_blocks.json").then(
              (data) => kAdditionalBlocks = List<Map<String, dynamic>>.from(
                jsonDecode(data),
              ),
            ),
        sharedPrefs.init(),
      ],
    );

    if(!kIsWeb) FlutterNativeSplash.remove();
  }

  Map<String, dynamic> get configs => config[appMode.name]!;

  static const config = {
    "debug": {
      "base": {},
      'unsplash': {
        'base_url': 'https://api.unsplash.com',
        'application_id': 579730,
        'access_key': "yJ0MiuIpIE_aunuyDS60eqqmxsdw4ImlczJrRNXSJao",
        'secret_key': "MfJhFteceOnxbt1EPBzRw7B5i-m0qb2gIZ2iF6hhKrg"
      }
    },
    "production": {
      "base": {},
      'unsplash': {
        'base_url': 'https://api.unsplash.com',
        'application_id': 579730,
        'access_key': "yJ0MiuIpIE_aunuyDS60eqqmxsdw4ImlczJrRNXSJao",
        'secret_key': "MfJhFteceOnxbt1EPBzRw7B5i-m0qb2gIZ2iF6hhKrg"
      }
    }
  };
}
