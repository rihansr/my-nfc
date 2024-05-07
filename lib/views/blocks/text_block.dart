import 'package:flutter/material.dart';
import '../../utils/extensions.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../views/blocks/components.dart';

class TextBlock extends StatelessWidget {
  final String path;
  final DashboardViewModel parent;
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;

  const TextBlock(
    this.configs, {
    required this.path,
    required this.parent,
    this.sectionStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final key = parent.key('$path/');

    String text = configs['subBlock'] == 'text_name'
        ? '${configs['data']?['name']?['first'] ?? ''}'
                ' '
                '${configs['data']?['name']?['middle'] ?? ''}'
                ' '
                '${configs['data']?['name']?['last'] ?? ''}'
            .trim()
        : '${configs['data']?['content'] ?? ''}'.trim();

    return text.isEmpty
        ? SizedBox.shrink(key: key)
        : Container(
            key: key,
            width: configs['data']?['style']?['text']?['alignment'] != null ||
                    sectionStyle?['alignment']?['horizontal'] != null
                ? double.infinity
                : null,
            decoration: BoxDecoration(
              color: configs['style']?['background']?['color']
                  ?.toString()
                  .hexColor,
              border: parent.isSelected(key) ? selectedBorder : null,
            ),
            padding: padding(configs['style']?['spacing']?['padding']),
            transform: transform(configs['style']?['spacing']?['margin']),
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
