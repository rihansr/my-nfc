import 'package:flutter/material.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import 'components.dart';

class SpaceBlock extends StatelessWidget {
  final String path;
  final DashboardViewModel parent;
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  const SpaceBlock(
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
      child: SizedBox(
        key: key,
        height: configs['data']?['style']?['height']?.toDouble() ?? 0.0,
      ),
    );
  }
}
