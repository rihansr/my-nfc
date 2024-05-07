import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../shared/drawables.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../widgets/clipper_widget.dart';
import 'components.dart';

class ImageBlock extends StatelessWidget {
  final String path;
  final DashboardViewModel parent;
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  final Uint8List? imageBytes;
  ImageBlock(
    this.configs, {
    required this.path,
    required this.parent,
    this.sectionStyle,
    super.key,
  }) : imageBytes = (() {
          String? encodedBytes = configs['data']?['bytes'];
          return encodedBytes == null ? null : base64Decode(encodedBytes);
        }());

  @override
  Widget build(BuildContext context) {
    final key = parent.key('$path/');

    return Container(
      key: key,
      decoration: BoxDecoration(
        border: parent.isSelected(key) ? selectedBorder : null,
      ),
      transform: transform(configs['style']?['spacing']?['margin']),
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
                size: double.parse(
                    '${configs['data']?['style']?['size'] ?? 100.0}'),
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
                    color: parent.theme.dividerColor,
                    fallbackWidth: double.infinity,
                  ),
                ),
      ),
    );
  }
}
