import 'package:flutter/material.dart';

class BlockActions extends StatelessWidget {
  final bool? settingsExpanded;
  final bool? visibility;
  final bool primary;
  final bool? dragable;
  final Function(bool visible)? onVisible;
  final Function(bool show)? onSettingsShown;
  const BlockActions({
    super.key,
    this.settingsExpanded,
    this.visibility,
    this.primary = false,
    this.dragable,
    this.onVisible,
    this.onSettingsShown,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onSettingsShown != null)
          SizedBox.square(
            dimension: 40,
            child: IconButton(
              onPressed: () {
                if (!primary) onSettingsShown?.call(!settingsExpanded!);
              },
              iconSize: 18,
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.settings,
                color: settingsExpanded!
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
            ),
          ),
        if (visibility != null)
          SizedBox.square(
            dimension: 40,
            child: IconButton(
              onPressed: () {
                if (!primary) onVisible?.call(!visibility!);
              },
              iconSize: 18,
              padding: EdgeInsets.zero,
              icon: Icon(
                visibility! ? Icons.visibility : Icons.visibility_off,
                color: primary ? Theme.of(context).disabledColor : null,
              ),
            ),
          ),
        if (dragable != null)
          SizedBox.square(
            dimension: 40,
            child: IconButton(
                onPressed: () {},
                iconSize: 20,
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.drag_indicator,
                  color: dragable! ? null : Theme.of(context).disabledColor,
                )),
          )
      ],
    );
  }
}
