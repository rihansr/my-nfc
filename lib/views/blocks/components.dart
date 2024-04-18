import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import '../../../utils/extensions.dart';
import '../../../viewmodels/design_viewmodel.dart';
import '../../shared/constants.dart';

Alignment? alignment(Map? alignment) {
  switch (
      '${alignment?['vertical'] ?? 'top'}-${alignment?['horizontal'] ?? 'left'}') {
    case 'top-left':
      return Alignment.topLeft;
    case 'top-center':
      return Alignment.topCenter;
    case 'top-right':
      return Alignment.topRight;
    case 'center-left':
      return Alignment.centerLeft;
    case 'center-center':
      return Alignment.center;
    case 'center-right':
      return Alignment.centerRight;
    case 'bottom-left':
      return Alignment.bottomLeft;
    case 'bottom-center':
      return Alignment.bottomCenter;
    case 'bottom-right':
      return Alignment.bottomRight;
    default:
      return null;
  }
}

CrossAxisAlignment horizontalAlignment(Object? alignment) {
  switch (alignment) {
    case 'start':
      return CrossAxisAlignment.start;
    case 'center':
      return CrossAxisAlignment.center;
    case 'end':
      return CrossAxisAlignment.end;
    default:
      return CrossAxisAlignment.stretch;
  }
}

MainAxisAlignment verticalAlignment(Object? alignment) {
  switch (alignment) {
    case "top":
      return MainAxisAlignment.start;
    case "center":
      return MainAxisAlignment.center;
    case "bottom":
      return MainAxisAlignment.end;
    default:
      return MainAxisAlignment.start;
  }
}

TextAlign? textAlign(Object? alignment) {
  switch (alignment) {
    case 'left':
      return TextAlign.left;
    case 'center':
      return TextAlign.center;
    case 'right':
      return TextAlign.right;
    default:
      return null;
  }
}

ImageProvider<Object>? providerPhoto(String? img, {String? placeholder}) =>
    (() {
      if (img?.isNotEmpty == true) {
        if ((Uri.tryParse(img!)?.isAbsolute ?? false) || kIsWeb) {
          return NetworkImage(img) as ImageProvider<Object>;
        } else {
          return FileImage(File(img));
        }
      } else {
        return placeholder?.isNotEmpty == true
            ? AssetImage(placeholder!)
            : null;
      }
    }());

Widget? photo(
  String? path, {
  String? placeholder,
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
}) {
  path ??= placeholder;
  return path?.isNotEmpty ?? false
      ? Uri.tryParse(path!)?.isAbsolute ?? false
          ? FadeInImage.memoryNetwork(
              image: path,
              width: width,
              height: height,
              fit: fit,
              placeholder: kTransparentImage,
            )
          : kIsWeb
              ? Image.network(path, width: width, height: height, fit: fit)
              : Image.file(File(path), width: width, height: height, fit: fit)
      : null;
}

TextStyle textStyle(BuildContext context, Map? style) =>
    GoogleFonts.getFont(
      style?['typography'] ??
          Provider.of<DesignViewModel>(context).theme.fontFamily,
      fontSize: style?['fontSize']?.toDouble() ?? 16,
      color: style?['textColor']?.toString().hexColor ??
          Provider.of<DesignViewModel>(context).theme.textColor,
      fontWeight: fontWeight(style?['fontWeight']),
    );

FontWeight fontWeight(Object? fontWeight) {
  switch (fontWeight) {
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
}

EdgeInsets margin(Map? spacing) => EdgeInsets.only(
      top: _abs(spacing?['top'] ?? spacing?['vertical'] ?? 0),
      bottom: _abs(spacing?['bottom'] ?? spacing?['vertical'] ?? 0),
      left: _abs(spacing?['left'] ?? spacing?['horizontal'] ?? 0),
      right: _abs(spacing?['right'] ?? spacing?['horizontal'] ?? 0),
    );

EdgeInsets padding(Map? spacing) => EdgeInsets.only(
      top: _abs(spacing?['top'] ?? spacing?['vertical'] ?? 0),
      bottom: _abs(spacing?['bottom'] ?? spacing?['vertical'] ?? 0),
      left: _abs(spacing?['left'] ?? spacing?['horizontal'] ?? 0),
      right: _abs(spacing?['right'] ?? spacing?['horizontal'] ?? 0),
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

Function()? launchUrl({Map? settings, Uri? url}) {
  url ??= settings?['linkTo'] == null ? null : Uri.parse(settings?['linkTo']);
  bool disabled = settings?['disabled'] ?? false;

  return () async => disabled || url == null
      ? null
      : await urlLauncher.launchUrl(
          url,
          webOnlyWindowName:
              settings?['openInNewTab'] == true ? '_blank' : '_self',
        );
}
