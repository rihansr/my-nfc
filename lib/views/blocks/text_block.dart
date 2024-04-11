import 'package:flutter/material.dart';
import '../../views/blocks/components.dart';

class TextBlock extends StatelessWidget {
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  const TextBlock(this.configs, {this.sectionStyle, super.key});

  @override
  Widget build(BuildContext context) {
    String text = configs['block'] == 'name'
        ? '${configs['data']?['name']?['first'] ?? ''}'
                ' '
                '${configs['data']?['name']?['middle'] ?? ''}'
                ' '
                '${configs['data']?['name']?['last'] ?? ''}'
            .trim()
        : '${configs['data']?['content'] ?? ''}'.trim();

    return text.isEmpty
        ? const SizedBox.shrink()
        : Container(
            width: configs['data']?['style']?['text']?['alignment'] != null ||
                    sectionStyle?['alignment']?['horizontal'] != null
                ? double.infinity
                : null,
            padding: padding(configs['style']?['spacing']?['padding']),
            margin: margin(configs['style']?['spacing']?['margin']),
            child: Text(
              text,
              textAlign: textAlign(configs['data']?['style']?['text']
                      ?['alignment'] ??
                  sectionStyle?['alignment']?['horizontal']),
              style: textStyle(context, configs['data']?['style']?['text']),
            ),
          );
  }
}
