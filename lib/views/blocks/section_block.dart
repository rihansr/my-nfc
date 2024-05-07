import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../../utils/extensions.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../widgets/clipper_widget.dart';
import '../../widgets/negative_padding.dart';
import 'actions_block.dart';
import 'additional_block.dart';
import 'button_block.dart';
import 'components.dart';
import 'contact_block.dart';
import 'divider_block.dart';
import 'image_block.dart';
import 'info_block.dart';
import 'links_block.dart';
import 'space_block.dart';
import 'text_block.dart';
import 'video_block.dart';

class SectionBlock extends StatelessWidget {
  final String path;
  final DashboardViewModel parent;
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;

  const SectionBlock(
    this.configs, {
    required this.path,
    required this.parent,
    this.sectionStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Stack(
      alignment: alignment(configs['style']?['alignment']) ?? Alignment.topLeft,
      children: [
        (() {
          Uint8List? bytes = (() {
            String? encodedBytes =
                configs['style']?['background']?['image']?['bytes'];
            return encodedBytes == null ? null : base64Decode(encodedBytes);
          }());
          double scale = configs['style']?['background']?['image']?['style']
                  ?['scale'] ??
              1.0;

          if (bytes == null) {
            return SizedBox(
                height: configs['subBlock'] == 'section_banner' ? 100 : 0);
          }
          Widget image = Clipper(
            overlayColor:
                configs['style']?['overlay']?['color']?.toString().hexColor ??
                    Colors.transparent,
            overlayOpacity:
                (configs['style']?['overlay']?['opacity'] ?? 0.0) / 100,
            child: Transform.scale(
              alignment: Alignment.center,
              scale: scale,
              child: photo(
                bytes,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),
          );
          return image;
        }()),
        Padding(
          padding: padding(configs['style']?['spacing']?['padding']),
          child: Column(
            crossAxisAlignment: horizontalAlignment(
                configs['style']?['alignment']?['horizontal']),
            mainAxisAlignment:
                verticalAlignment(configs['style']?['alignment']?['vertical']),
            mainAxisSize: MainAxisSize.min,
            children: (configs['data']?['fields'] as List?)?.where((element) {
                  if (element['subBlock'] == 'actions_footer' &&
                      (element['settings']?['advanced']
                              ?['buttonFixedAtBottom'] ??
                          true)) {
                    return false;
                  }
                  return true;
                }).mapIndexed(
                  (i, e) {
                    String path = '${this.path}/$i';
                    Key key = Key(path);

                    Map<String, dynamic> sectionStyle =
                        Map<String, dynamic>.from(this.configs['style'] ?? {});

                    Map<String, dynamic> configs = Map<String, dynamic>.from(e);

                    if (configs['settings']?['visible'] == false) {
                      return SizedBox.shrink(key: key);
                    }

                    late Widget field;

                    switch (configs['block']) {
                      case "section":
                        field = SectionBlock(
                          configs,
                          path: path,
                          parent: parent,
                          sectionStyle: sectionStyle,
                          key: key,
                        );
                      case "space":
                        field = SpaceBlock(
                          configs,
                          path: path,
                          parent: parent,
                          sectionStyle: sectionStyle,
                          key: key,
                        );
                      case "divider":
                        field = DividerBlock(
                          configs,
                          path: path,
                          parent: parent,
                          sectionStyle: sectionStyle,
                          key: key,
                        );
                      case "text":
                        field = TextBlock(
                          configs,
                          path: path,
                          parent: parent,
                          sectionStyle: sectionStyle,
                          key: key,
                        );
                      case "image":
                        field = ImageBlock(
                          configs,
                          path: path,
                          parent: parent,
                          sectionStyle: sectionStyle,
                          key: key,
                        );
                      case "contact":
                        field = ContactBlock(
                          configs,
                          path: path,
                          parent: parent,
                          sectionStyle: sectionStyle,
                          key: key,
                        );
                      case "info":
                        field = InfoBlock(
                          configs,
                          path: path,
                          parent: parent,
                          sectionStyle: sectionStyle,
                          key: key,
                        );
                      case "links":
                        field = LinksBlock(
                          configs,
                          path: path,
                          parent: parent,
                          sectionStyle: sectionStyle,
                          key: key,
                        );
                      case "button":
                        field = ButtonBlock(
                          configs,
                          path: path,
                          parent: parent,
                          sectionStyle: sectionStyle,
                          key: key,
                        );
                      case "video":
                        field = VideoBlock(
                          configs,
                          path: path,
                          parent: parent,
                          sectionStyle: sectionStyle,
                          key: key,
                        );
                      case "additional":
                        field = AdditionalBlock(
                          configs,
                          path: path,
                          parent: parent,
                          sectionStyle: sectionStyle,
                          key: key,
                        );
                      case "actions":
                        field = ActionsBlock(
                          configs,
                          path: path,
                          parent: parent,
                          sectionStyle: sectionStyle,
                          key: key,
                        );
                      default:
                        field = SizedBox.shrink(key: key);
                    }

                    return configs['style']?['spacing']?['outset'] != null
                        ? NegativePadding(
                            padding:
                                margin(configs['style']?['spacing']?['outset']),
                            child: field)
                        : field;
                  },
                ).toList() ??
                [],
          ),
        ),
      ],
    );

    final key = parent.key('$path/');

    return Container(
      key: key,
      width: configs['style']?['fullWidth'] == false ? null : double.infinity,
      decoration: BoxDecoration(
        color: configs['style']?['background']?['color']?.toString().hexColor,
        border: parent.isSelected(key) ? selectedBorder : null,
      ),
      transform: transform(configs['style']?['spacing']?['margin']),
      margin: margin(configs['style']?['spacing']?['margin']),
      child: InkWell(
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: openUrl(settings: configs['settings']?['advanced']),
        child: configs['subBlock'] == 'section_banner'
            ? NegativePadding(
                padding: EdgeInsets.symmetric(
                  horizontal: parent.theme.horizontalPadding,
                ),
                child: child,
              )
            : child,
      ),
    );
  }
}
