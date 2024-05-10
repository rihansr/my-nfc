import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
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
    if (kIsWeb) {
      usePathUrlStrategy();
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ));
    }

    await Future.wait(
      [
        if (!kIsWeb)
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]),
        rootBundle
            .loadString("assets/files/dummy_blocks.json")
            .then((data) => kDefaultBlocks = data),
        rootBundle
            .loadString("assets/files/additional_blocks.json")
            .then((data) => kAdditionalBlocks = data),
        rootBundle
            .loadString("assets/files/social_links.json")
            .then((data) => kSocialLinks = data),
        rootBundle.loadString("assets/files/country_codes.json").then(
              (data) => kCountryCodes.addAll(
                List<Map<String, dynamic>>.from(json.decode(data)),
              ),
            ),
        sharedPrefs.init(),
      ],
    );

    if (!kIsWeb) FlutterNativeSplash.remove();

    /// Hive Init
    final appDocumentDir = kIsWeb
        ? await getTemporaryDirectory()
        : await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    localDb = await Hive.openBox('my_nfc');
  }

  Map<String, dynamic> get configs => config[appMode.name]!;

  static const config = {
    "debug": {
      "base": {
        'domain': 'mynfc.com',
      },
      'unsplash': {
        'base_url': 'https://api.unsplash.com',
        'access_key': "yJ0MiuIpIE_aunuyDS60eqqmxsdw4ImlczJrRNXSJao",
        'secret_key': "MfJhFteceOnxbt1EPBzRw7B5i-m0qb2gIZ2iF6hhKrg"
      }
    },
    "production": {
      "base": {
        'domain': 'mynfc.com',
      },
      'unsplash': {
        'base_url': 'https://api.unsplash.com',
        'access_key': "yJ0MiuIpIE_aunuyDS60eqqmxsdw4ImlczJrRNXSJao",
        'secret_key': "MfJhFteceOnxbt1EPBzRw7B5i-m0qb2gIZ2iF6hhKrg"
      }
    }
  };
}
