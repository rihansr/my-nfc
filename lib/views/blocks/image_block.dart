import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/drawables.dart';
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
        onTap: configs['settings']?['advanced']?['linkTo'] != null
            ? () async => await launchUrl(
                  Uri.parse(configs['settings']['advanced']['linkTo']),
                  webOnlyWindowName: configs['settings']?['advanced']
                              ?['openInNewTab'] ==
                          true
                      ? '_blank'
                      : '_self',
                )
            : null,
        child: configs['block'] == 'avatar'
            ? CircleAvatar(
                backgroundColor: Colors.black12,
                backgroundImage: providerPhoto(configs['data']?['path'],
                    placeholder: drawable.avatar),
                radius:
                    (configs['data']?['style']?['size']?.toDouble() ?? 100.0) / 2,
              )
            : photo(
                configs['data']?['path'],
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),
      ),
    );
  }
}
