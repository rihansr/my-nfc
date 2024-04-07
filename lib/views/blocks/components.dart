import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../utils/extensions.dart';
import '../../../viewmodels/design_viewmodel.dart';

CrossAxisAlignment horizontalAlignment(Object? alignment) {
  switch (alignment) {
    case 'center':
      return CrossAxisAlignment.center;
    case 'end':
      return CrossAxisAlignment.end;
    case 'start':
    default:
      return CrossAxisAlignment.start;
  }
}

MainAxisAlignment verticalAlignment(Object? alignment) {
  switch (alignment) {
    case "center":
      return MainAxisAlignment.center;
    case "bottom":
      return MainAxisAlignment.end;
    case "top":
    default:
      return MainAxisAlignment.start;
  }
}

TextAlign textAlign(Object? alignment) {
  switch (alignment) {
    case 'center':
      return TextAlign.center;
    case 'right':
      return TextAlign.right;
    case 'left':
    default:
      return TextAlign.left;
  }
}

TextStyle textStyle(BuildContext context, Map? style) => GoogleFonts.getFont(
      style?['typography'] ??
          Provider.of<DesignViewModel>(context).theme.fontFamily,
      fontSize: style?['fontSize']?.toDouble() ?? 16,
      color: style?['textColor']?.toString().hexColor ??
          Provider.of<DesignViewModel>(context).theme.textColor,
      fontWeight: (() {
        switch (style?['fontWeight']) {
          case 'thin':
            return FontWeight.w200;
          case 'light':
            return FontWeight.w300;
          case 'regular':
            return FontWeight.w400;
          case 'medium':
            return FontWeight.w500;
          case 'semi-bold':
            return FontWeight.w600;
          case 'bold':
            return FontWeight.w700;
          case 'extra bold':
            return FontWeight.w800;
          case 'black':
            return FontWeight.w900;
          default:
            return FontWeight.normal;
        }
      }()),
    );

EdgeInsets margin(Map? margin) => EdgeInsets.only(
      top: _abs(margin?['top'] ?? 0),
      bottom: _abs(margin?['bottom'] ?? 0),
      left: _abs(margin?['left'] ?? 0),
      right: _abs(margin?['right'] ?? 0),
    );

EdgeInsets padding(Map? padding) => EdgeInsets.symmetric(
      vertical: _abs(padding?['vertical'] ?? 0),
      horizontal: _abs(padding?['horizontal'] ?? 0),
    );

Matrix4 transform(Map? margin) {
  num top = margin?['top'] ?? 0;
  num bottom = margin?['bottom'] ?? 0;
  num left = margin?['left'] ?? 0;
  num right = margin?['right'] ?? 0;
  return Matrix4.translationValues(
    left < 0 || right < 0 ? (left - right).toDouble() : 0,
    top < 0 || bottom < 0 ? (top - bottom).toDouble() : 0,
    0,
  );
}

double _abs(num val) => val < 0 ? 0.0 : val.toDouble();
