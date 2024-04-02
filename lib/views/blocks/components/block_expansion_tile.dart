import 'package:flutter/material.dart';
import '../../../shared/strings.dart';
import '../../../shared/constants.dart';

class BlockExpansionTile extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final Widget? child;
  final Map<String, dynamic>? controllers;
  final EdgeInsetsGeometry titlePadding;
  final EdgeInsetsGeometry? padding;
  final bool enableBorder;
  final bool maintainState;
  final List<Widget> children;
  final Function(MapEntry<String, dynamic>)? onUpdate;
  final Function()? onRemove;
  final Function(bool)? onExpansionChanged;

  BlockExpansionTile({
    super.key,
    this.icon,
    this.label,
    this.child,
    this.titlePadding = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.enableBorder = false,
    this.maintainState = true,
    this.children = const [],
    this.onExpansionChanged,
  })  : controllers = null,
        onUpdate = null,
        onRemove = null,
        visible = ValueNotifier(false),
        childExpanded = ValueNotifier(false),
        childrenExpanded = ValueNotifier(false);

  BlockExpansionTile.settings(
    this.controllers, {
    super.key,
    this.icon,
    this.label,
    this.child,
    this.titlePadding = const EdgeInsets.symmetric(horizontal: 10),
    this.padding,
    this.enableBorder = false,
    this.maintainState = false,
    this.children = const [],
    this.onUpdate,
    this.onRemove,
    this.onExpansionChanged,
  })  : visible = ValueNotifier(controllers?['visible'] == true),
        childExpanded = ValueNotifier(controllers?['expandConfigs'] == true),
        childrenExpanded = ValueNotifier(false);

  final ValueNotifier<bool> visible;
  final ValueNotifier<bool> childExpanded;
  final ValueNotifier<bool> childrenExpanded;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ListTileTheme(
      dense: true,
      horizontalTitleGap: 5.0,
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
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        onExpansionChanged: (state) {
          childrenExpanded.value = state;
          onExpansionChanged?.call(state);
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
        trailing: controllers == null || controllers?['hideControllers'] == true
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (child != null)
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
                      if (controllers?['primary'] == true) return;
                      visible.value = !visible.value;
                      onUpdate?.call(MapEntry('visible', visible.value));
                    },
                    icon: ValueListenableBuilder(
                      valueListenable: visible,
                      builder: (_, isVisible, __) {
                        return Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off,
                          color: (controllers?['primary'] ?? false)
                              ? theme.disabledColor
                              : theme.iconTheme.color,
                        );
                      },
                    ),
                  ),
                  _IconButton(
                    icon: Icon(
                      Icons.drag_indicator,
                      color: (controllers?['dragable'] ?? false)
                          ? theme.hintColor
                          : theme.disabledColor,
                    ),
                  ),
                ],
              ),
        children: [
          if (child != null)
            ValueListenableBuilder(
              valueListenable: childExpanded,
              builder: (_, isExpanded, __) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: isExpanded
                    ? DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: theme.colorScheme.primary),
                          ),
                        ),
                        child: Column(
                          key: UniqueKey(),
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 8, 22, 0),
                              child: child!,
                            ),
                            const SizedBox(height: 16)
                          ],
                        ),
                      )
                    : SizedBox.shrink(key: UniqueKey()),
              ),
            ),
          ...children,
          if (controllers?['removable'] == true) ...[
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
