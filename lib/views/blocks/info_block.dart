import 'package:flutter/material.dart';

import 'components.dart';

class InfoBlock extends StatelessWidget {
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  const InfoBlock(this.configs, {this.sectionStyle, super.key});

  @override
  Widget build(BuildContext context) {
    return configs['data']?['title']?['text'] == null &&
            configs['data']?['content']?['text'] == null
        ? const SizedBox.shrink()
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  configs['label'] ?? '',
                  style: textStyle(
                    context,
                    {'fontWeight': 'semi-bold', 'fontSize': 14},
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if ((configs['data'] as Map?)?.containsKey('title') ??
                        false) ...[
                      Text(
                        configs['data']?['content']?['text'] ?? '',
                        style: textStyle(
                          context,
                          {'fontWeight': 'semi-bold', 'fontSize': 14},
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      configs['data']?['title']?['text'] ?? '',
                      style: textStyle(
                        context,
                        {'fontWeight': 'regular', 'fontSize': 10},
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
  }
}
