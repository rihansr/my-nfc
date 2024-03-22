import 'package:flutter/material.dart';
import '../../../shared/constants.dart';
import 'settings_actions.dart';

class ExpansionSettingsTile extends StatelessWidget {
  final IconData? icon;
  final Map<String, dynamic> data;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry titlePadding;
  final bool maintainState;
  final bool enableBoder;
  final Function(bool)? onExpansionChanged;
  final Function(bool)? onVisible;
  final Function(bool)? onSettingsShown;
  const ExpansionSettingsTile(
    this.data, {
    super.key,
    this.icon,
    this.titlePadding = const EdgeInsets.symmetric(horizontal: 10),
    this.padding,
    this.onExpansionChanged,
    this.maintainState = false,
    this.enableBoder = false,
    this.onVisible,
    this.onSettingsShown,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
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
            horizontalTitleGap: 5.0,
            minLeadingWidth: 0,
            child: ExpansionTile(
              key: key,
              shape: enableBoder
                  ? Border(
                      left: BorderSide(color: theme.colorScheme.primary),
                    )
                  : const Border(),
              tilePadding: titlePadding,
              childrenPadding: padding,
              expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
              onExpansionChanged: onExpansionChanged,
              maintainState: maintainState,
              title: Text(
                data['label'] ?? '',
                style: const TextStyle(
                  fontFamily: kFontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              textColor: icon != null ? theme.colorScheme.primary : null,
              iconColor: icon != null ? theme.colorScheme.primary : null,
              controlAffinity: ListTileControlAffinity.leading,
              leading: icon == null ? null : Icon(icon!, size: 16),
              trailing: SettingsActions(
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
