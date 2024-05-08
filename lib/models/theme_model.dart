import 'package:flutter/material.dart';

class ThemeModel {
  final int id;
  final List<Color> colors;
  final List<double> stops;
  final Color textColor;
  final Color iconColor;
  final Color dividerColor;
  final double horizontalPadding;
  final String fontFamily;

  const ThemeModel({
    required this.id,
    required this.colors,
    required this.stops,
    required this.textColor,
    required this.iconColor,
    required this.dividerColor,
    this.horizontalPadding = 20,
    this.fontFamily = 'Open Sans',
  });

  ThemeModel copyWith({
    int? id,
    List<Color>? colors,
    List<double>? stops,
    Color? textColor,
    Color? iconColor,
    Color? dividerColor,
    double? horizontalPadding,
    String? fontFamily,
  }) =>
      ThemeModel(
        id: id ?? this.id,
        colors: colors ?? this.colors,
        stops: stops ?? this.stops,
        textColor: textColor ?? this.textColor,
        iconColor: iconColor ?? this.iconColor,
        dividerColor: dividerColor ?? this.dividerColor,
        horizontalPadding: horizontalPadding ?? this.horizontalPadding,
        fontFamily: fontFamily ?? this.fontFamily,
      );

  // to json
  Map<String, dynamic> toMap() => {
        'id': id,
        'colors': colors.map((e) => e.value).toList(),
        'stops': stops,
        'textColor': textColor.value,
        'iconColor': iconColor.value,
        'dividerColor': dividerColor.value,
        'horizontalPadding': horizontalPadding,
        'fontFamily': fontFamily,
      };

  // from json
  factory ThemeModel.fromMap(Map<String, dynamic> map) => ThemeModel(
        id: map['id'],
        colors: (map['colors'] as List).map((e) => Color(e)).toList(),
        stops: List<double>.from(map['stops']),
        textColor: Color(map['textColor']),
        iconColor: Color(map['iconColor']),
        dividerColor: Color(map['dividerColor']),
        horizontalPadding: map['horizontalPadding'],
        fontFamily: map['fontFamily'],
      );

  ThemeModel inheritFrom(ThemeModel theme) => ThemeModel(
        id: id,
        colors: colors,
        stops: stops,
        textColor: textColor,
        iconColor: iconColor,
        dividerColor: dividerColor,
        horizontalPadding: theme.horizontalPadding,
        fontFamily: theme.fontFamily,
      );

  Gradient get background => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
        stops: stops,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
