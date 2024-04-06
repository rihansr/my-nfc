import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../../utils/extensions.dart';
import '../../widgets/clipper_widget.dart';
import 'actions_block.dart';
import 'additional_block.dart';
import 'button_block.dart';
import 'contact_block.dart';
import 'divider_block.dart';
import 'image_block.dart';
import 'info_block.dart';
import 'links_block.dart';
import 'space_block.dart';
import 'text_block.dart';
import 'video_block.dart';

class SectionBlock extends StatelessWidget {
  final Map<String, dynamic> configs;
  const SectionBlock(this.configs, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: configs['settings']?['additional']?['openInNewTab'] == true
          ? () => {}
          : null,
      child: Clipper(
        width: configs['style']?['fullWidth'] == false ? null : double.infinity,
        color: configs['style']?['background']?['color']?.toString().hexColor,
        padding: EdgeInsets.symmetric(
          vertical: configs['style']?['padding']?['vertical']?.toDouble() ?? 0,
          horizontal:
              configs['style']?['padding']?['horizontal']?.toDouble() ?? 0,
        
        ),
        margin: EdgeInsets.only(
          top: configs['style']?['margin']?['top']?.toDouble() ?? 0,
          bottom: configs['style']?['margin']?['bottom']?.toDouble() ?? 0,
          left: configs['style']?['margin']?['left']?.toDouble() ?? 0,
          right: configs['style']?['margin']?['right']?.toDouble() ?? 0,
        ),
        backdrop: (() {
          String? path = configs['style']?['background']?['image']?['path'];
          if (path == null) return null;
          double scale = configs['style']?['background']?['image']?['style']
                  ?['scale'] ??
              1.0;

          return Uri.tryParse(path)?.isAbsolute ?? false
              ? DecorationImage(
                  image: NetworkImage(path, scale: scale),
                  fit: BoxFit.cover,
                )
              : kIsWeb
                  ? DecorationImage(
                      image: NetworkImage(path, scale: scale),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: FileImage(File(path), scale: scale),
                      fit: BoxFit.cover,
                    );
        }()),
        overlayColor:
            configs['style']?['overlay']?['color']?.toString().hexColor,
        overlayOpacity: (configs['style']?['overlay']?['opacity'] ?? 0.0) / 100,
        child: Column(
          crossAxisAlignment: (() {
            switch (configs['style']?['alignment']?['horizontal']) {
              case "right":
                return CrossAxisAlignment.end;
              case "center":
                return CrossAxisAlignment.center;
              case "left":
              default:
                return CrossAxisAlignment.start;
            }
          }()),
          mainAxisAlignment: (() {
            switch (configs['style']?['alignment']?['vertical']) {
              case "bottom":
                return MainAxisAlignment.end;
              case "center":
                return MainAxisAlignment.center;
              case "top":
              default:
                return MainAxisAlignment.start;
            }
          }()),
          mainAxisSize: MainAxisSize.min,
          children: (configs['data']?['fields'] as List?)?.mapIndexed(
                (i, e) {
                  Key key =
                      this.key != null ? Key('${this.key}/$i') : Key('$i');
                  Map<String, dynamic> configs = Map<String, dynamic>.from(e);
                  switch (configs['block']) {
                    case "section":
                    case "section-secure":
                      return SectionBlock(configs, key: key);
                    case "space":
                      return SpaceBlock(configs, key: key);
                    case "divider":
                      return DividerBlock(configs, key: key);
                    case "text":
                    case "name":
                      return TextBlock(configs, key: key);
                    case "avatar":
                    case "image":
                      return ImageBlock(configs, key: key);
                    case "contact":
                      return ContactBlock(configs, key: key);
                    case "info":
                      return InfoBlock(configs, key: key);
                    case "links-public":
                    case "links":
                      return LinksBlock(configs, key: key);
                    case "button":
                      return ButtonBlock(configs, key: key);
                    case "video":
                      return VideoBlock(configs, key: key);
                    case "additional":
                      return AdditionalBlock(configs, key: key);
                    case "actions":
                      return ActionsBlock(configs, key: key);
                    default:
                      return SizedBox.shrink(key: key);
                  }
                },
              ).toList() ??
              [],
        ),
      ),
    );
  }
}
