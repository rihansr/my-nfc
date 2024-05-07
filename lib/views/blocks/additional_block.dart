import 'package:flutter/material.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import 'components.dart';

class AdditionalBlock extends StatelessWidget {
  final String path;
  final DashboardViewModel parent;
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  const AdditionalBlock(
    this.configs, {
    required this.path,
    required this.parent,
    this.sectionStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final key = parent.key('$path/');

    return DecoratedBox(
      decoration: BoxDecoration(
        border: parent.isSelected(key) ? selectedBorder : null,
      ),
      child: ListView(
        key: key,
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        children: (configs['data']?['fields'] as List?)
                ?.where((field) =>
                    field['field'] != null || field['description'] != null)
                .map(
                  (field) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${field['title']}',
                        textAlign: textAlign(configs['data']?['style']
                                ?['alignment']?['horizontal'] ??
                            sectionStyle?['alignment']?['horizontal']),
                        style: textStyle(
                            context, configs['data']?['style']?['title']),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${field['description']}',
                        textAlign: textAlign(configs['data']?['style']
                                ?['alignment']?['horizontal'] ??
                            sectionStyle?['alignment']?['horizontal']),
                        style: textStyle(
                            context, configs['data']?['style']?['description']),
                      ),
                    ],
                  ),
                )
                .toList() ??
            [],
      ),
    );
  }
}
