import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/extensions.dart';
import '../../viewmodels/design_viewmodel.dart';
import 'components.dart';

class DividerBlock extends StatelessWidget {
  final Map<String, dynamic> configs;
  const DividerBlock(this.configs, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: margin(configs['style']?['spacing']?['margin']),
      child: Divider(
        thickness: configs['data']?['style']?['height']?.toDouble() ?? 1.0,
        indent: configs['style']?['spacing']?['padding']?['left']?.toDouble() ??
            0.0,
        endIndent:
            configs['style']?['spacing']?['padding']?['right']?.toDouble() ??
                0.0,
        color:
            configs['data']?['style']?['dividerColor']?.toString().hexColor ??
                Provider.of<DesignViewModel>(context).theme.dividerColor,
      ),
    );
  }
}
