import 'package:flutter/material.dart';
import '../../../viewmodels/base_viewmodel.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';
import '../../../shared/strings.dart';
import '../../../shared/constants.dart';
import 'block_style.dart';

class BlockExpansionTile extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final Map<String, dynamic>? settings;
  final Map<String, dynamic>? style;
  final Map<String, dynamic>? defaultStyle;
  final EdgeInsetsGeometry titlePadding;
  final EdgeInsetsGeometry? padding;
  final bool enableBorder;
  final bool maintainState;
  final bool initiallyExpanded;
  final List<Widget> children;
  final Function(String, MapEntry<String, dynamic>)? onUpdate;
  final Function()? onRemove;
  final Function(bool)? onExpansionChanged;

  BlockExpansionTile({
    super.key,
    this.icon,
    this.label,
    this.titlePadding = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.enableBorder = false,
    this.maintainState = true,
    this.initiallyExpanded = false,
    this.children = const [],
    this.onExpansionChanged,
  })  : settings = null,
        style = null,
        defaultStyle = null,
        onUpdate = null,
        onRemove = null,
        visible = ValueNotifier(false),
        childExpanded = ValueNotifier(false),
        childrenExpanded = ValueNotifier(false);

  BlockExpansionTile.settings(
    this.settings, {
    super.key,
    this.style,
    this.defaultStyle,
    this.icon,
    this.label,
    this.titlePadding = const EdgeInsets.symmetric(horizontal: 10),
    this.padding,
    this.enableBorder = false,
    this.maintainState = false,
    this.initiallyExpanded = false,
    this.children = const [],
    this.onUpdate,
    this.onRemove,
    this.onExpansionChanged,
  })  : visible = ValueNotifier(settings?['visible'] == true),
        childExpanded = ValueNotifier(settings?['expandConfigs'] == true),
        childrenExpanded = ValueNotifier(false);

  final ValueNotifier<bool> visible;
  final ValueNotifier<bool> childExpanded;
  final ValueNotifier<bool> childrenExpanded;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ListTileTheme(
      dense: true,
      horizontalTitleGap: 6.0,
      minLeadingWidth: 0,
      child: ExpansionTile(
        key: Key('$key/expansion_tile'),
        shape: enableBorder
            ? Border(
                left: BorderSide(color: theme.colorScheme.primary),
              )
            : const Border(),
        tilePadding: titlePadding,
        childrenPadding: padding,
        initiallyExpanded: initiallyExpanded,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        onExpansionChanged: (state) {
          childrenExpanded.value = state;
          onExpansionChanged?.call(state);
          provider<DashboardViewModel>().scroll(state ? key : null);
        },
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
        trailing: settings == null || settings?['hideControllers'] == true
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (style != null ||
                      settings?['settings']?['advanced'] != null)
                    ValueListenableBuilder(
                        valueListenable: childrenExpanded,
                        builder: (_, isExpanded, __) {
                          return IgnorePointer(
                            ignoring: !isExpanded,
                            child: _IconButton(
                              onPressed: () {
                                childExpanded.value = !childExpanded.value;
                              },
                              icon: ValueListenableBuilder(
                                valueListenable: childExpanded,
                                builder: (_, isChildExpanded, __) {
                                  return Icon(
                                    Icons.settings,
                                    color: isChildExpanded && isExpanded
                                        ? theme.colorScheme.primary
                                        : theme.iconTheme.color,
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                  _IconButton(
                    onPressed: () {
                      if (settings?['primary'] == true) return;
                      visible.value = !visible.value;
                      onUpdate?.call(
                          'settings', MapEntry('visible', visible.value));
                    },
                    icon: ValueListenableBuilder(
                      valueListenable: visible,
                      builder: (_, isVisible, __) {
                        return Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off,
                          color: (settings?['primary'] ?? false)
                              ? theme.disabledColor
                              : theme.iconTheme.color,
                        );
                      },
                    ),
                  ),
                  _IconButton(
                    icon: Icon(
                      Icons.drag_indicator,
                      color: (settings?['dragable'] ?? false)
                          ? theme.hintColor
                          : theme.disabledColor,
                    ),
                  ),
                ],
              ),
        children: [
          if (style != null || settings?['settings']?['advanced'] != null)
            ValueListenableBuilder(
              valueListenable: childExpanded,
              builder: (_, isExpanded, __) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: isExpanded
                    ? Container(
                        key: UniqueKey(),
                        margin: icon == null
                            ? const EdgeInsets.fromLTRB(12, 0, 22, 0)
                            : const EdgeInsets.all(0),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        color: theme.colorScheme.primary.withOpacity(0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BlockStyle(
                              style ?? {},
                              defaultStyle: defaultStyle,
                              settings: settings!['settings']?['advanced'],
                              onUpdate: (style) {
                                onUpdate?.call('style', style);
                              },
                              onSettingsUpdate: (settings) {
                                onUpdate?.call(
                                    'settings', MapEntry('advanced', settings));
                              },
                            ),
                            const SizedBox(height: 16)
                          ],
                        ),
                      )
                    : SizedBox.shrink(key: UniqueKey()),
              ),
            ),
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

class _IconButton extends StatelessWidget {
  final Widget icon;
  final Function()? onPressed;

  const _IconButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 32,
      child: IconButton(
        onPressed: onPressed,
        iconSize: 18,
        padding: EdgeInsets.zero,
        icon: icon,
      ),
    );
  }
}
