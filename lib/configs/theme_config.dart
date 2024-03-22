import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../shared/colors.dart';
import '../shared/constants.dart';

ThemeData theming(BuildContext context, ThemeMode mode) {
  ColorPalette colorPalette;
  switch (mode) {
    case ThemeMode.light:
      colorPalette = ColorPalette.light();
      break;
    case ThemeMode.dark:
    default:
      colorPalette = ColorPalette.dark();
  }

  return ThemeData(
    fontFamily: kFontFamily,
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    pageTransitionsTheme: kIsWeb
        ? null
        : Platform.isAndroid
            ? const PageTransitionsTheme(
                builders: <TargetPlatform, PageTransitionsBuilder>{
                  TargetPlatform.android: ZoomPageTransitionsBuilder(),
                },
              )
            : null,
    appBarTheme: const AppBarTheme().copyWith(
      titleTextStyle: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w700,
        color: colorPalette.text,
        height: 1.95,
      ),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: colorPalette.primary,
      onPrimary: colorPalette.onPrimary,
      secondary: colorPalette.secondary,
      onSecondary: colorPalette.onSecondary,
      tertiary: colorPalette.tertiary,
      onTertiary: colorPalette.onTertiary,
      background: colorPalette.scaffold,
      onBackground: colorPalette.scaffold,
      surface: colorPalette.surface,
      onSurface: colorPalette.onSurface,
      error: colorPalette.error,
      onError: colorPalette.error,
    ),
    primaryColor: colorPalette.primary,
    dividerColor: colorPalette.divider,
    splashColor: Colors.transparent,
    focusColor: colorPalette.focus,
    scaffoldBackgroundColor: colorPalette.scaffold,
    primaryColorDark: colorPalette.primaryDark,
    primaryColorLight: colorPalette.primaryLight,
    disabledColor: colorPalette.disable,
    hintColor: colorPalette.hint,
    iconTheme: IconThemeData(
      color: colorPalette.icon,
      size: 24,
    ),
    snackBarTheme: const SnackBarThemeData().copyWith(
      backgroundColor: colorPalette.primary,
      actionTextColor: colorPalette.text,
      contentTextStyle: TextStyle(
        fontSize: 12,
        color: colorPalette.text,
        fontWeight: FontWeight.w300,
        height: 1.5,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    expansionTileTheme: const ExpansionTileThemeData().copyWith(
      textColor: colorPalette.text,
      collapsedTextColor: colorPalette.hint,
      collapsedIconColor: colorPalette.hint,
      iconColor: colorPalette.icon,
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      childrenPadding: const EdgeInsets.only(left: 28),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: colorPalette.headline,
        height: 1.95,
      ),
      displayMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: colorPalette.headline,
        height: 1.2,
      ),
      displaySmall: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: colorPalette.headline,
        height: 1.2,
      ),
      headlineLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: colorPalette.headline,
        height: 2.4,
      ),
      headlineMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: colorPalette.headline,
        height: 1.2,
      ),
      headlineSmall: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: colorPalette.headline,
        height: 1.2,
      ),
      titleLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: colorPalette.text,
        height: 1.5,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: colorPalette.text,
        height: 1.2,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: colorPalette.text,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colorPalette.text,
        height: 1.2,
      ),
      titleMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: colorPalette.text,
        height: 1.3,
      ),
      titleSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: colorPalette.text,
        height: 1.0,
      ),
      labelLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: colorPalette.text,
        height: 1.22,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colorPalette.text,
        height: 1.1,
      ),
      labelSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorPalette.text,
        height: 1.22,
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w300,
      ),
      labelColor: colorPalette.headline,
      unselectedLabelColor: colorPalette.headline,
      indicator: const UnderlineTabIndicator(borderSide: BorderSide.none),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return colorPalette.surface;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return colorPalette.surface;
        }
        return null;
      }),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: colorPalette.hint,
      inactiveTrackColor: colorPalette.hint,
      trackHeight: 1,
      thumbColor: colorPalette.primary,
      overlayShape: SliderComponentShape.noOverlay,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4.5),
      valueIndicatorColor: colorPalette.primary,
    ),
    bottomAppBarTheme: const BottomAppBarTheme(color: Colors.transparent),
  );
}
