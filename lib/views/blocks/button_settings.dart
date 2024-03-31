import 'package:flutter/material.dart';
import '../../shared/constants.dart';
import '../../utils/extensions.dart';
import '../../shared/strings.dart';
import '../../widgets/checkbox_widget.dart';
import '../../widgets/colour_picker_widget.dart';
import '../../widgets/dropdown_widget.dart';
import '../../widgets/input_field_widget.dart';
import '../../widgets/seekbar_widget.dart';
import '../../widgets/tab_widget.dart';
import 'components/expansion_settings_tile.dart';
import 'components/spcaing.dart';

// ignore: must_be_immutable
class ButtonSettings extends StatelessWidget {
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  late Color? _selectedBorderColor;
  late int _selectedBorderThickness;
  late int _selectedBorderRadius;
  late bool _fullWidth;
  late String? _selectedFonFamily;
  late Color? _selectedFontColor;
  late int _selectedFontSize;
  late String? _selectedFontWeight;
  late bool _openInNewTab;
  late bool _disabled;

  ButtonSettings({
    super.key,
    required this.block,
    this.onUpdate,
  })  : _selectedBorderColor =
            block['style']?['border']?['color']?.toString().hexColor,
        _selectedBorderThickness = block['style']?['border']?['thickness'] ?? 1,
        _selectedBorderRadius = block['style']?['border']?['radius'] ?? 4,
        _fullWidth = block['settings']?['additional']?['fullWidth'] ?? false,
        _selectedFonFamily = block['data']?['style']?['text']?['typography'],
        _selectedFontColor =
            block['data']?['style']?['text']?['color']?.toString().hexColor,
        _selectedFontSize = block['data']?['style']?['text']?['fontSize'] ?? 16,
        _selectedFontWeight =
            block['data']?['style']?['text']?['fontWeight'] ?? 'regular',
        _openInNewTab =
            block['settings']?['additional']?['openInNewTab'] ?? true,
        _disabled = block['settings']?['additional']?['disabled'] ?? false;

  update(String key, MapEntry<String, dynamic> value) {
    Map<String, dynamic> settings = Map.from(block);
    switch (key) {
      case 'data':
      case 'style':
        settings.addEntry(key, value);
      case 'border':
        settings['style'] ??= {};
        (settings['style'] as Map<String, dynamic>).addEntry(key, value);
      case 'text':
        settings['data'] ??= {};
        settings['data']['style'] ??= {};
        (settings['data']['style'] as Map<String, dynamic>)
            .addEntry(key, value);
      case 'additional':
        settings['settings'] ??= {};
        (settings['settings'] as Map<String, dynamic>).addEntry(key, value);
      default:
        settings['data'] ??= {};
        (settings['data'] as Map<String, dynamic>).addEntry(key, value);
    }
    onUpdate?.call(settings);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionSettingsTile.settings(
      block['settings'],
      key: Key('$key'),
      icon: Icons.add_circle_outline,
      label: block['label'],
      enableBoder: true,
      onUpdate: (entry) {
        block.addEntry('settings', entry);
        onUpdate?.call(block);
      },
      onRemove: () => onUpdate?.call({}),
      padding: const EdgeInsets.fromLTRB(12, 0, 22, 8),
      maintainState: true,
      children: [
        InputField(
          controller:
              TextEditingController(text: block['data']?['label']?['text']),
          title: string.buttonText,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 2,
          onTyping: (text) => update(
            'label',
            MapEntry('text', text.isEmpty ? null : text),
          ),
        ),
        InputField(
          controller: TextEditingController(text: block['data']?['link']),
          title: string.linkTo,
          onTyping: (text) => update(
            'data',
            MapEntry('link', text.isEmpty ? null : text),
          ),
        ),
        ExpansionSettingsTile(
          label: string.buttonDesign,
          padding: const EdgeInsets.all(0),
          titlePadding: const EdgeInsets.all(0),
          maintainState: true,
          children: [
            ColourPicker(
              title: string.borderCcolor,
              value: _selectedBorderColor,
              colors: kColors,
              onPick: (color) {
                _selectedBorderColor = color;
                update('border', MapEntry('color', color.toHex));
              },
            ),
            Seekbar(
              title: string.borderThickness,
              type: 'px',
              value: _selectedBorderThickness,
              min: 0,
              max: 100,
              onChanged: (size) {
                _selectedBorderThickness = size;
                update('border', MapEntry('thickness', size));
              },
            ),
            Seekbar(
              title: string.borderRadius,
              type: 'px',
              value: _selectedBorderRadius,
              min: 0,
              max: 50,
              onChanged: (radius) {
                _selectedBorderRadius = radius;
                update('border', MapEntry('radius', radius));
              },
            ),
            CheckboxWidget.expand(
              value: _fullWidth,
              label: string.fullWidth,
              onChanged: (checked) {
                _fullWidth = checked;
                update('additional', MapEntry('fullWidth', checked));
              },
            ),
            Dropdown<String?>(
              title: string.typography,
              hint: string.selectOne,
              items: [null, ...kFontFamilys],
              value: _selectedFonFamily,
              maintainState: true,
              itemBuilder: (p0) =>
                  Text(p0?.replaceAll('_', ' ') ?? string.fromThemeSettings),
              onSelected: (String? font) {
                _selectedFonFamily = font;
                update('text', MapEntry('typography', font));
              },
            ),
            Seekbar(
              title: string.fontSize,
              value: _selectedFontSize,
              min: 8,
              max: 96,
              onChanged: (size) {
                _selectedFontSize = size;
                update('text', MapEntry('fontSize', size));
              },
            ),
            ColourPicker(
              title: string.textColor,
              value: _selectedFontColor,
              colors: kColors,
              onPick: (color) {
                _selectedFontColor = color;
                update('text', MapEntry('color', color.toHex));
              },
            ),
            TabWidget(
              title: string.fontWeight,
              tabs: kFontWeights,
              value: _selectedFontWeight,
              onSelect: (weight) {
                _selectedFontWeight = weight;
                update('text', MapEntry('fontWeight', weight));
              },
            ),
            CheckboxWidget.expand(
              value: _openInNewTab,
              label: string.fullWidth,
              onChanged: (checked) {
                _openInNewTab = checked;
                update('additional', MapEntry('openInNewTab', checked));
              },
            ),
            CheckboxWidget.expand(
              value: _disabled,
              label: string.disabled,
              onChanged: (checked) {
                _disabled = checked;
                update('additional', MapEntry('disabled', checked));
              },
            ),
          ],
        ),
        Spacing(
          title: string.paddingAndMarginSettings,
          padding: block['style']?['padding'],
          margin: block['style']?['margin'],
          onUpdate: (spacing) => update('style', spacing),
        ),
      ],
    );
  }
}
