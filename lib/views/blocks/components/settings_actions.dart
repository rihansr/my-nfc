import 'package:flutter/material.dart';
import 'package:my_nfc/shared/colors.dart';

class SettingsActions extends StatelessWidget {
  final bool settingsExpanded;
  final bool visible;
  final bool primary;
  final bool dragable;
  final Function(bool visible)? onVisible;
  final Function(bool show)? onSettingsShown;

  const SettingsActions({
    super.key,
    this.settingsExpanded = false,
    this.visible = false,
    this.primary = false,
    this.dragable = false,
    this.onVisible,
    this.onSettingsShown,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onSettingsShown != null)
          SizedBox.square(
            dimension: 40,
            child: IconButton(
              onPressed: () {
                if (!primary) onSettingsShown?.call(!settingsExpanded);
              },
              iconSize: 18,
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.settings,
                color: settingsExpanded ? theme.colorScheme.primary : null,
              ),
            ),
          ),
        SizedBox.square(
          dimension: 40,
          child: IconButton(
            onPressed: () {
              if (!primary) onVisible?.call(!visible);
            },
            iconSize: 18,
            padding: EdgeInsets.zero,
            icon: Icon(
              visible ? Icons.visibility : Icons.visibility_off,
              color: primary
                  ? theme.disabledColor
                  : ColorPalette.current().subtitle,
            ),
          ),
        ),
        SizedBox.square(
          dimension: 40,
          child: IconButton(
            onPressed: () {},
            iconSize: 20,
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.drag_indicator,
              color: dragable ? theme.hintColor : theme.disabledColor,
            ),
          ),
        ),
      ],
    );
  }
}
