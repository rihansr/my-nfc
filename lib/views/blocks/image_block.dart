import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/drawables.dart';
import '../../viewmodels/design_viewmodel.dart';
import 'components.dart';

class ImageBlock extends StatelessWidget {
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  const ImageBlock(this.configs, {this.sectionStyle, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin(configs['style']?['spacing']?['margin']),
      alignment: alignment(configs['style']?['alignment']),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: openUrl(settings: configs['settings']?['advanced']),
        child: configs['subBlock'] == 'image_avatar'
            ? CircleAvatar(
                backgroundColor: Colors.black12,
                backgroundImage: providerPhoto(configs['data']?['path'],
                    placeholder: drawable.avatar),
                radius:
                    (configs['data']?['style']?['size']?.toDouble() ?? 100.0) /
                        2,
              )
            : photo(
                  configs['data']?['path'],
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
