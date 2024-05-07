import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/extensions.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import 'components.dart';

class DividerBlock extends StatelessWidget {
  final String path;
  final DashboardViewModel parent;
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  const DividerBlock(
    this.configs, {
    required this.path,
    required this.parent,
    this.sectionStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final key = parent.key('$path/');

    return Container(
      key: key,
      decoration: BoxDecoration(
        border: parent.isSelected(key) ? selectedBorder : null,
      ),
      padding: padding(configs['style']?['spacing']?['padding']),
      margin: margin(configs['style']?['spacing']?['margin']),
      transform: transform(configs['style']?['spacing']?['margin']),
      child: Divider(
        thickness: configs['data']?['style']?['height']?.toDouble() ?? 1.0,
        indent: configs['style']?['spacing']?['padding']?['left']?.toDouble() ??
            0.0,
        endIndent:
            configs['style']?['spacing']?['padding']?['right']?.toDouble() ??
                0.0,
        color:
            configs['data']?['style']?['dividerColor']?.toString().hexColor ??
                Provider.of<DashboardViewModel>(context).theme.dividerColor,
      ),
    );
  }
}
