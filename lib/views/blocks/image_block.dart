import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/drawables.dart';
import '../../viewmodels/design_viewmodel.dart';
import '../../widgets/clipper_widget.dart';
import 'components.dart';

class ImageBlock extends StatelessWidget {
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  final Uint8List? imageBytes;
  ImageBlock(this.configs, {this.sectionStyle, super.key})
      : imageBytes = (() {
          String? encodedBytes = configs['data']?['bytes'];
          return encodedBytes == null ? null : base64Decode(encodedBytes);
        }());

  @override
  Widget build(BuildContext context) {
    return Container(
      key: GlobalKey(debugLabel: '$key'),
      margin: margin(configs['style']?['spacing']?['margin']),
      alignment: alignment(configs['style']?['alignment']),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: openUrl(settings: configs['settings']?['advanced']),
        child: configs['subBlock'] == 'image_avatar'
            ? Clipper.circle(
                color: Colors.black12,
                size: double.parse('${configs['data']?['style']?['size'] ?? 100.0}'),
                child: photo(imageBytes,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    placeholder: drawable.avatar),
              )
            : photo(
                  imageBytes,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                ) ??
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Placeholder(
                    color: Provider.of<DesignViewModel>(context)
                        .theme
                        .dividerColor,
                    fallbackWidth: double.infinity,
                  ),
                ),
      ),
    );
  }
}
