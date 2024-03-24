import 'package:flutter/material.dart';
import '../../../shared/colors.dart';

class BlockSettings extends StatefulWidget {
  final Map<String, dynamic>? settings;
  final Function(MapEntry<String, dynamic>)? onUpdate;

  const BlockSettings({
    super.key,
    this.settings,
    this.onUpdate,
  });

  @override
  State<BlockSettings> createState() => _BlockSettingsState();
}

class _BlockSettingsState extends State<BlockSettings> {
  late bool _isExpanded;
  late bool _isVisible;
  late bool _isDragable;
  late bool _isPrimary;

  @override
  void initState() {
    _isExpanded = widget.settings?['expand'] ?? false;
    _isVisible = widget.settings?['visible'] ?? false;
    _isDragable = widget.settings?['dragable'] ?? false;
    _isPrimary = widget.settings?['primary'] ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.settings?.containsKey('expand') ?? false)
          SizedBox.square(
            dimension: 32,
            child: IconButton(
              onPressed: () {
                setState(() => _isExpanded = !_isExpanded);
              },
              iconSize: 18,
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.settings,
                color: _isExpanded ? theme.colorScheme.primary : null,
              ),
            ),
          ),
        SizedBox.square(
          dimension: 32,
          child: IconButton(
            onPressed: () {
              if (widget.settings?['primary'] == true) return;
              setState(() => _isVisible = !_isVisible);
              widget.onUpdate?.call(MapEntry('visible', _isVisible));
            },
            iconSize: 18,
            padding: EdgeInsets.zero,
            icon: Icon(
              _isVisible ? Icons.visibility : Icons.visibility_off,
              color: _isPrimary
                  ? theme.disabledColor
                  : ColorPalette.current().subtitle,
            ),
          ),
        ),
        SizedBox.square(
          dimension: 32,
          child: IconButton(
            onPressed: () {},
            iconSize: 20,
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.drag_indicator,
              color: _isDragable ? theme.hintColor : theme.disabledColor,
            ),
          ),
        ),
      ],
    );
  }
}
