import 'package:flutter/material.dart';
import 'package:my_nfc/shared/drawables.dart';
import 'components.dart';

class ImageBlock extends StatelessWidget {
  final Map<String, dynamic> configs;
  const ImageBlock(this.configs, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin(configs['style']?['spacing']?['margin']),
      alignment: alignment(configs['style']?['alignment']),
      child: configs['block'] == 'avatar'
          ? CircleAvatar(
              backgroundColor: Colors.black12,
              backgroundImage: providerPhoto(configs['data']?['path'], placeholder: drawable.avatar),
              radius:
                  (configs['data']?['style']?['size']?.toDouble() ?? 100.0) / 2,
            )
          : photo(configs['data']?['path']),
    );
  }
}
