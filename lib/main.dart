import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'configs/app_config.dart';
import 'configs/app_settings.dart';
import 'configs/theme_config.dart';
import 'routes/routing.dart';
import 'services/navigation_service.dart';

Future<void> main() async =>
    appConfig.init().then((_) => runApp(const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appSettings.settings,
      builder: (_, settings, __) => MaterialApp.router(
        title: 'My NFC',
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: navigator.scaffoldMessengerKey,
        themeMode: ThemeMode.system,
        theme: theming(_, ThemeMode.light),
        darkTheme: theming(_, ThemeMode.dark),
        locale: settings.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
  }
}
