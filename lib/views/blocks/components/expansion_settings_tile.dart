import 'package:flutter/material.dart';
import '../../../shared/strings.dart';
import '../../../shared/constants.dart';
import 'block_actions.dart';

class ExpansionSettingsTile extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final Widget? child;
  final Map<String, dynamic>? settings;
  final EdgeInsetsGeometry titlePadding;
  final EdgeInsetsGeometry? padding;
  final bool enableBoder;
  final bool maintainState;
  final List<Widget> children;
  final Function(MapEntry<String, dynamic>)? onUpdate;
  final Function()? onRemove;
  final Function(bool)? onExpansionChanged;

  const ExpansionSettingsTile({
    super.key,
    this.icon,
    this.label,
    this.child,
    this.titlePadding = const EdgeInsets.symmetric(horizontal: 10),
    this.padding,
    this.enableBoder = false,
    this.maintainState = false,
    this.children = const [],
    this.onExpansionChanged,
  })  : settings = null,
        onUpdate = null,
        onRemove = null;

  const ExpansionSettingsTile.settings(
    this.settings, {
    super.key,
    this.icon,
    this.label,
    this.child,
    this.titlePadding = const EdgeInsets.symmetric(horizontal: 10),
    this.padding,
    this.enableBoder = false,
    this.maintainState = false,
    this.children = const [],
    this.onUpdate,
    this.onRemove,
    this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ListTileTheme(
      dense: true,
      horizontalTitleGap: 5.0,
      minLeadingWidth: 0,
      child: ExpansionTile(
        key: Key('$key/expansion_tile'),
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
          label ?? '',
          style: const TextStyle(
            fontFamily: kFontFamily,
            fontSize: 14,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
        ),
        textColor: icon != null ? theme.colorScheme.primary : null,
        iconColor: icon != null ? theme.colorScheme.primary : null,
        controlAffinity: ListTileControlAffinity.leading,
        leading: icon == null ? null : Icon(icon!, size: 16),
        trailing: settings == null
            ? null
            : BlockActions(settings: settings, onUpdate: onUpdate),
        children: [
          if (child != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 22, 8),
              child: child!,
            ),
            const SizedBox(height: 16)
          ],
          ...children,
          if (settings?['removable'] == true) ...[
            const SizedBox(height: 16),
            Divider(
              height: 1,
              thickness: 1,
              color: theme.colorScheme.error,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => onRemove?.call(),
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
