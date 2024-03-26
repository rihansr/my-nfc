import 'package:flutter/material.dart';
import '../../shared/constants.dart';
import '../../shared/strings.dart';
import '../../utils/extensions.dart';
import '../../widgets/colour_picker_widget.dart';
import 'components/expansion_settings_tile.dart';
import 'components/spcaing.dart';

// ignore: must_be_immutable
class DividerSettings extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>)? onUpdate;

  late Color _selectedColor;

  DividerSettings({
    super.key,
    required this.settings,
    this.onUpdate,
  }) : _selectedColor =
            settings['data']?['style']?['color']?.toString().hexColor ??
                Colors.grey;

  update(MapEntry<String, dynamic> value) {
    settings['data'] ??= {};
    (settings['data'] as Map<String, dynamic>).addEntry('style', value);
    onUpdate?.call(settings);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionSettingsTile(
      settings,
      maintainState: true,
      icon: Icons.remove_outlined,
      padding: const EdgeInsets.fromLTRB(14, 0, 24, 8),
      enableBoder: true,
      onUpdate: onUpdate,
      children: [
        Spacing(
          margin: settings['data']?['style']?['margin'],
          onUpdate: (spacing) => update(spacing),
        ),
        ColourPicker(
          title: string.color,
          value: _selectedColor,
          colors: kColors,
          onPick: (color) {
            _selectedColor = color;
            update(MapEntry('color', color.toHex));
          },
        ),
      ],
    );
  }
}
