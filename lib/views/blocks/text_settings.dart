import 'package:flutter/material.dart';
import '../../widgets/tab_widget.dart';
import '../../widgets/colour_picker_widget.dart';
import '../../widgets/seekbar_widget.dart';
import '../../utils/extensions.dart';
import '../../shared/constants.dart';
import '../../shared/strings.dart';
import '../../widgets/input_field_widget.dart';
import '../../widgets/dropdown_widget.dart';
import 'components/settings_expansion_tile.dart';
import 'components/spcaing.dart';

// ignore: must_be_immutable
class TextSettings extends StatelessWidget {
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  late String? _selectedFonFamily;
  late int _selectedFontSize;
  late Color? _selectedFontColor;
  late String? _selectedFontWeight;
  late String? _selectedAlignment;

  TextSettings({
    super.key,
    required this.block,
    this.onUpdate,
  })  : _selectedFonFamily = block['data']?['style']?['text']?['typography'],
        _selectedFontSize = block['data']?['style']?['text']?['fontSize'] ?? 12,
        _selectedFontColor =
            block['data']?['style']?['text']?['color']?.toString().hexColor,
        _selectedFontWeight =
            block['data']?['style']?['text']?['fontWeight'] ?? 'regular',
        _selectedAlignment =
            block['data']?['style']?['text']?['alignment'] ?? 'left';

  update(String key, MapEntry<String, dynamic> value) {
    Map<String, dynamic> settings = Map.from(block);
    switch (key) {
      case 'data':
      case 'style':
        settings.addEntry(key, value);
      case 'text':
        settings['data'] ??= {};
        settings['data']['style'] ??= {};
        (settings['data']['style'] as Map<String, dynamic>)
            .addEntry(key, value);
      default:
        settings['data'] ??= {};
        (settings['data'] as Map<String, dynamic>).addEntry(key, value);
    }
    onUpdate?.call(settings);
  }

  @override
  Widget build(BuildContext context) {
    return SettingsExpansionTile.settings(
      block['settings'],
      key: Key('$key'),
      icon: Icons.title,
      label: block['label'],
      enableBorder: true,
      onUpdate: (entry) {
        block.addEntry('settings', entry);
        onUpdate?.call(block);
      },
      onRemove: () => onUpdate?.call({}),
      maintainState: true,
      padding: const EdgeInsets.fromLTRB(14, 0, 22, 8),
      children: [
        ...(block['block'] == 'name'
            ? [
                InputField(
                  controller: TextEditingController(
                      text: block['data']?['name']?['first']),
                  title: string.firstName,
                  textCapitalization: TextCapitalization.words,
                  onTyping: (text) => update(
                    'name',
                    MapEntry('first', text.isEmpty ? null : text),
                  ),
                ),
                InputField(
                  controller: TextEditingController(
                      text: block['data']?['name']?['middle']),
                  title: string.middleName,
                  textCapitalization: TextCapitalization.words,
                  onTyping: (text) => update(
                    'name',
                    MapEntry('middle', text.isEmpty ? null : text),
                  ),
                ),
                InputField(
                  controller: TextEditingController(
                      text: block['data']?['name']?['last']),
                  title: string.lastName,
                  textCapitalization: TextCapitalization.words,
                  onTyping: (text) => update(
                    'name',
                    MapEntry('last', text.isEmpty ? null : text),
                  ),
                ),
              ]
            : [
                InputField(
                  controller:
                      TextEditingController(text: block['data']?['content']),
                  minLines: 2,
                  maxLines: 8,
                  title: string.content,
                  textCapitalization: TextCapitalization.sentences,
                  onTyping: (text) => update(
                    'data',
                    MapEntry('content', text.isEmpty ? null : text),
                  ),
                ),
              ]),
        Dropdown<String?>(
          title: string.typography,
          hint: string.selectOne,
          items: [null, ...kFontFamilys],
          value: _selectedFonFamily,
          maintainState: true,
          itemBuilder: (item) =>
              Text(item?.replaceAll('_', ' ') ?? string.fromThemeSettings),
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
        TabWidget(
          title: string.alignment,
          tabs: kHorizontalAlignments,
          value: _selectedAlignment,
          onSelect: (alignment) {
            _selectedAlignment = alignment;
            update('text', MapEntry('alignment', alignment));
          },
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
