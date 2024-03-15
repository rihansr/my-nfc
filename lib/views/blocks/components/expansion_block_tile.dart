import 'package:flutter/material.dart';
import '../../../shared/constants.dart';
import 'block_actions.dart';

class ExpansionBlockTile extends StatelessWidget {
  final IconData? icon;
  final Map<String, dynamic> data;
  final List<Widget> children;
  final Function(bool)? onVisible;
  const ExpansionBlockTile(
    this.data, {
    super.key,
    this.icon,
    this.onVisible,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      dense: true,
      horizontalTitleGap: 8.0,
      minLeadingWidth: 0,
      child: ExpansionTile(
        key: key,
        title: data['label'] == null
            ? const SizedBox.shrink()
            : Text(
                data['label'] ?? '',
                style: const TextStyle(
                  fontFamily: kFontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
        controlAffinity: ListTileControlAffinity.leading,
        leading: icon == null
            ? null
            : data['label'] == null
                ? const SizedBox.shrink()
                : Icon(icon!, size: 16),
        initiallyExpanded: data['label'] == null,
        trailing: BlockActions(
          visibility: data['visibility'],
          primary: (data['primary'] as bool?) ?? false,
          dragable: data['dragable'],
          onVisible: onVisible,
        ),
        children: children,
      ),
    );
  }
}
