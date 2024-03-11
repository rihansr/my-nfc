import 'package:flutter/material.dart';

class Settings {
  final ThemeMode themeMode;
  final Locale locale;

  const Settings({
    this.themeMode = ThemeMode.dark,
    this.locale = const Locale('en', ''),
  });

  Settings copyWith({
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        themeMode: ThemeMode.values.byName(json["themeMode"]),
        locale: Locale(json["locale"]),
      );

  Map<String, dynamic> toJson() => {
        "themeMode": themeMode.name,
        "locale": locale.languageCode,
      };
}
