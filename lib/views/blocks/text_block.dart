import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/theme_model.dart';
import '../../utils/extensions.dart';
import '../../viewmodels/design_viewmodel.dart';

class TextBlock extends StatelessWidget {
  final Map<String, dynamic> configs;
  const TextBlock(this.configs, {super.key});

  @override
  Widget build(BuildContext context) {
    ThemeModel defaultTheme =
        Provider.of<DesignViewModel>(context, listen: false).theme;
    String text = configs['block'] == 'name'
        ? '${configs['data']?['name']?['first'] ?? ''} ${configs['data']?['name']?['middle'] ?? ''} ${configs['data']?['name']?['last'] ?? ''}'
            .trim()
        : '${configs['data']?['content'] ?? ''}'.trim();

    return text.isEmpty
        ? const SizedBox.shrink()
        : Container(
            width: configs['data']?['style']?['text']?['alignment'] != null
                ? double.infinity
                : null,
            padding: EdgeInsets.symmetric(
              vertical:
                  configs['style']?['padding']?['vertical']?.toDouble() ?? 0,
              horizontal:
                  configs['style']?['padding']?['horizontal']?.toDouble() ?? 0,
            ),
            margin: EdgeInsets.only(
              top: configs['style']?['margin']?['top']?.toDouble() ?? 0,
              bottom: configs['style']?['margin']?['bottom']?.toDouble() ?? 0,
              left: configs['style']?['margin']?['left']?.toDouble() ?? 0,
              right: configs['style']?['margin']?['right']?.toDouble() ?? 0,
            ),
            child: Text(
              text,
              textAlign: (() {
                switch (configs['data']?['style']?['text']?['alignment']) {
                  case 'center':
                    return TextAlign.center;
                  case 'right':
                    return TextAlign.right;
                  case 'left':
                  default:
                    return TextAlign.left;
                }
              }()),
              style: GoogleFonts.getFont(
                  configs['data']?['style']?['text']?['typography'] ??
                      defaultTheme.fontFamily,
                  fontSize: configs['data']?['style']?['text']?['fontSize']
                          ?.toDouble() ??
                      16,
                  color: configs['data']?['style']?['text']?['textColor']
                          ?.toString()
                          .hexColor ??
                      defaultTheme.textColor,
                  fontWeight: (() {
                    switch (configs['data']?['style']?['text']?['fontWeight']) {
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
                      default:
                        return FontWeight.normal;
                    }
                  }())),
            ),
          );
  }
}
