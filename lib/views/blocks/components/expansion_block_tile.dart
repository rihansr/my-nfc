import 'package:flutter/material.dart';
import '../../../shared/constants.dart';
import 'block_actions.dart';

class ExpansionBlockTile extends StatelessWidget {
  final IconData? icon;
  final Map<String, dynamic> data;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? titlePadding;
  final bool? maintainState;
  final Function(bool)? onExpansionChanged;
  final Function(bool)? onVisible;
  final Function(bool)? onSettingsShown;
  const ExpansionBlockTile(
    this.data, {
    super.key,
    this.icon,
    this.titlePadding,
    this.padding,
    this.onExpansionChanged,
    this.onVisible,
    this.onSettingsShown,
    this.maintainState,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return data['label'] == null
        ? Padding(
            padding: padding ?? const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          )
        : ListTileTheme(
            dense: true,
            horizontalTitleGap: 6.0,
            minLeadingWidth: 0,
            child: ExpansionTile(
              key: key,
              maintainState: maintainState ?? false,
              tilePadding:
                  titlePadding ?? const EdgeInsets.symmetric(horizontal: 12),
              childrenPadding: padding,
              expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
              onExpansionChanged: onExpansionChanged,
              title: Text(
                data['label'] ?? '',
                style: const TextStyle(
                  fontFamily: kFontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              leading: icon == null ? null : Icon(icon!, size: 16),
              trailing: BlockActions(
                settingsExpanded: data['settings']?["initiallyExpand"],
                visibility: data['visibility'],
                primary: (data['primary'] as bool?) ?? false,
                dragable: data['dragable'],
                onVisible: onVisible,
                onSettingsShown: onSettingsShown,
              ),
              children: children,
            ),
          );
  }
}
