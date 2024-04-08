import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';
import '../../utils/extensions.dart';
import '../../viewmodels/design_viewmodel.dart';
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
  final Map<String, dynamic> configs;
  const SectionBlock(this.configs, {super.key});

  @override
  Widget build(BuildContext context) {
    Widget child = Stack(
      alignment: alignment(configs['style']?['alignment']),
      children: [
        (() {
          String? path = configs['style']?['background']?['image']?['path'];
          if (path == null) {
            return SizedBox(height: configs['label'] == 'Banner' ? 100 : 0);
          }
          double scale = configs['style']?['background']?['image']?['style']
                  ?['scale'] ??
              1.0;
          Widget image = Clipper(
            overlayColor:
                configs['style']?['overlay']?['color']?.toString().hexColor ??
                    Colors.transparent,
            overlayOpacity:
                (configs['style']?['overlay']?['opacity'] ?? 0.0) / 100,
            child: Transform.scale(
              alignment: Alignment.center,
              scale: scale,
              child: photo(path),
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
            children: (configs['data']?['fields'] as List?)?.mapIndexed(
                  (i, e) {
                    Key key =
                        this.key != null ? Key('${this.key}/$i') : Key('$i');
                    Map<String, dynamic> configs = Map<String, dynamic>.from(e);
                    if (configs['settings']?['visible'] == false) {
                      return SizedBox.shrink(key: key);
                    }
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
      ],
    );
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: configs['settings']?['additional']?['openInNewTab'] == true
          ? () => {}
          : null,
      child: Container(
        width: configs['style']?['fullWidth'] == false ? null : double.infinity,
        color: configs['style']?['background']?['color']?.toString().hexColor,
        transform: transform(configs['style']?['spacing']?['margin']),
        margin: margin(configs['style']?['spacing']?['margin']),
        child: configs['label'] == 'Banner'
            ? NegativePadding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      Provider.of<DesignViewModel>(context, listen: false)
                          .theme
                          .horizontalPadding,
                ),
                child: child,
              )
            : child,
      ),
    );
  }
}
