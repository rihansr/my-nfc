import 'package:flutter/material.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import 'components.dart';

class InfoBlock extends StatelessWidget {
  final String path;
  final DashboardViewModel parent;
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  const InfoBlock(
    this.configs, {
    required this.path,
    required this.parent,
    this.sectionStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final key = parent.key('$path/');

    return configs['data']?['title']?['text'] == null &&
            configs['data']?['content']?['text'] == null
        ? SizedBox.shrink(key: key)
        : DecoratedBox(
            decoration: BoxDecoration(
              border: parent.isSelected(key) ? selectedBorder : null,
            ),
            child: Row(
              key: key,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (() {
                  final text = Text(
                    configs['label'] ?? '',
                    style: textStyle(
                      context,
                      {'fontWeight': 'semi-bold', 'fontSize': 14},
                    ),
                  );
                  return sectionStyle?['fullWidth'] == false
                      ? SizedBox(width: 104, child: text)
                      : Expanded(flex: 1, child: text);
                }()),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if ((configs['data'] as Map?)?.containsKey('content') ??
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
                          {'fontWeight': 'regular', 'fontSize': 11},
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
