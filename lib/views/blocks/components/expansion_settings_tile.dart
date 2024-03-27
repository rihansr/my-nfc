import 'package:flutter/material.dart';
import '../../../shared/strings.dart';
import '../../../utils/extensions.dart';
import '../../../shared/constants.dart';
import 'block_settings.dart';

class ExpansionSettingsTile extends StatelessWidget {
  final IconData? icon;
  final Map<String, dynamic> data;
  final EdgeInsetsGeometry titlePadding;
  final EdgeInsetsGeometry? padding;
  final bool enableBoder;
  final bool maintainState;
  final List<Widget> children;
  final Function(Map<String, dynamic>)? onUpdate;
  final Function(bool)? onExpansionChanged;

  const ExpansionSettingsTile(
    this.data, {
    super.key,
    this.icon,
    this.titlePadding = const EdgeInsets.symmetric(horizontal: 10),
    this.padding,
    this.enableBoder = false,
    this.maintainState = false,
    this.children = const [],
    this.onUpdate,
    this.onExpansionChanged,
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
              maintainState: false,
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
              trailing:
                  data['block'] == null || data['block'] == 'section-parent'
                      ? null
                      : BlockSettings(
                          settings: data['settings'],
                          onUpdate: (entry) {
                            data.addEntry('settings', entry);
                            onUpdate?.call(data);
                          },
                        ),
              children: [
                ...children,
                if (data['settings']?['removable'] == true) ...[
                  const SizedBox(height: 16),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: theme.colorScheme.error,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => onUpdate?.call({}),
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
