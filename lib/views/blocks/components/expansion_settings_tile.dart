import 'package:flutter/material.dart';
import 'package:my_nfc/shared/strings.dart';
import '../../../shared/constants.dart';
import 'settings_actions.dart';

class ExpansionSettingsTile extends StatelessWidget {
  final IconData? icon;
  final Map<String, dynamic> settings;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry titlePadding;
  final bool maintainState;
  final bool enableBoder;
  final Function(bool)? onExpansionChanged;
  final Function(bool)? onVisible;
  final Function(bool)? onSettingsShown;
  final Function()? onRemove;
  const ExpansionSettingsTile(
    this.settings, {
    super.key,
    this.icon,
    this.titlePadding = const EdgeInsets.symmetric(horizontal: 10),
    this.padding,
    this.onExpansionChanged,
    this.maintainState = false,
    this.enableBoder = false,
    this.onVisible,
    this.onSettingsShown,
    this.onRemove,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return settings['label'] == null
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
                settings['label'] ?? '',
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
              trailing: settings['visible'] == null && settings['dragable'] == null
                  ? null
                  : SettingsActions(
                      settingsExpanded:
                          (settings['settings']?["initiallyExpand"] as bool?) ??
                              false,
                      visible: (settings['visible'] as bool?) ?? false,
                      primary: (settings['primary'] as bool?) ?? false,
                      dragable: (settings['dragable'] as bool?) ?? false,
                      onVisible: onVisible,
                      onSettingsShown: onSettingsShown,
                    ),
              children: [
                ...children,
                if(settings['removable'] == true)...[
                  const SizedBox(height: 16),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: theme.colorScheme.error,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      ),
                      icon: Icon(
                        Icons.delete_outline_outlined,
                        size: 16,
                        color: theme.colorScheme.error,
                      ),
                      label: Text(
                        string.removeBlock,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          );
  }
}
