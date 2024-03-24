import 'package:flutter/material.dart';
import '../../widgets/tab_widget.dart';
import '../../widgets/colour_picker_widget.dart';
import '../../widgets/seekbar_widget.dart';
import '../../utils/extensions.dart';
import '../../shared/constants.dart';
import '../../shared/strings.dart';
import '../../widgets/input_field_widget.dart';
import '../../widgets/dropdown_widget.dart';
import 'components/expansion_settings_tile.dart';
import 'components/spcaing.dart';

// ignore: must_be_immutable
class TextSettings extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>)? onUpdate;

  final TextEditingController _contentController;
  final TextEditingController _firstNameController;
  final TextEditingController _middleNameController;
  final TextEditingController _lastNameController;

  late String? _selectedFonFamily;
  late int _selectedFontSize;
  late Color? _selectedFontColor;
  late String? _selectedFontWeight;
  late String? _selectedAlignment;

  TextSettings({
    super.key,
    required this.settings,
    this.onUpdate,
  })  : _contentController =
            TextEditingController(text: settings['data']?['content']),
        _firstNameController =
            TextEditingController(text: settings['data']?['name']?['first']),
        _middleNameController =
            TextEditingController(text: settings['data']?['name']?['middle']),
        _lastNameController =
            TextEditingController(text: settings['data']?['name']?['last']),
        _selectedFonFamily = settings['data']?['style']?['fontFamily'],
        _selectedFontSize = settings['data']?['style']?['fontSize'] ?? 12,
        _selectedFontColor =
            settings['data']?['style']?['color']?.toString().hexColor,
        _selectedFontWeight =
            settings['data']?['style']?['fontWeight'] ?? 'regular',
        _selectedAlignment = settings['data']?['style']?['alignment'] ?? 'left';

  updateSettings(String key, MapEntry<String, dynamic> value) {
    switch (key) {
      case 'data':
        settings.addEntry(key, value);
      default:
        settings['data'] ??= {};
        (settings['data'] as Map<String, dynamic>).addEntry(key, value);
    }
    onUpdate?.call(settings);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionSettingsTile(
      settings,
      maintainState: true,
      icon: Icons.title,
      padding: const EdgeInsets.fromLTRB(14, 0, 26, 8),
      enableBoder: true,
      onUpdate: onUpdate,
      children: [
        ...(settings['block'] == 'name'
            ? [
                InputField(
                  controller: _firstNameController,
                  title: string.firstName,
                  textCapitalization: TextCapitalization.words,
                  onTyping: (text) => updateSettings(
                    'name',
                    MapEntry('first', text.isEmpty ? null : text),
                  ),
                ),
                InputField(
                  controller: _middleNameController,
                  title: string.middleName,
                  textCapitalization: TextCapitalization.words,
                  onTyping: (text) => updateSettings(
                    'name',
                    MapEntry('middle', text.isEmpty ? null : text),
                  ),
                ),
                InputField(
                  controller: _lastNameController,
                  title: string.lastName,
                  textCapitalization: TextCapitalization.words,
                  onTyping: (text) => updateSettings(
                    'name',
                    MapEntry('last', text.isEmpty ? null : text),
                  ),
                ),
              ]
            : [
                InputField(
                  controller: _contentController,
                  minLines: 2,
                  maxLines: 8,
                  title: string.content,
                  textCapitalization: TextCapitalization.sentences,
                  onTyping: (text) => updateSettings(
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
          itemBuilder: (p0) =>
              Text(p0?.replaceAll('_', ' ') ?? string.fromThemeSettings),
          onSelected: (String? font) {
            _selectedFonFamily = font;
            updateSettings('style', MapEntry('fontFamily', font));
          },
        ),
        Seekbar(
          title: string.fontSize,
          value: _selectedFontSize,
          min: 8,
          max: 96,
          onChanged: (size) {
            _selectedFontSize = size;
            updateSettings('style', MapEntry('fontSize', size));
          },
        ),
        ColourPicker(
          title: string.textColor,
          value: _selectedFontColor,
          colors: const [
            Colors.white,
            Colors.black,
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.yellow,
            Colors.orange,
            Colors.purple,
            Colors.pink,
            Colors.teal,
            Colors.brown
          ],
          onPick: (color) {
            _selectedFontColor = color;
            updateSettings('style', MapEntry('color', color.toHex));
          },
        ),
        TabWidget(
            title: string.fontWeight,
            tabs: kFontWeights,
            value: _selectedFontWeight,
            onSelect: (weight) {
              _selectedFontWeight = weight;
              updateSettings('style', MapEntry('fontWeight', weight));
            }),
        TabWidget(
            title: string.alignment,
            tabs: kAlignments,
            value: _selectedAlignment,
            onSelect: (alignment) {
              _selectedAlignment = alignment;
              updateSettings('style', MapEntry('alignment', alignment));
            }),
        Spacing(
          title: string.paddingAndMarginSettings,
          padding: settings['data']?['padding'],
          margin: settings['data']?['margin'],
          onUpdate: (spacing) => updateSettings('data', spacing),
        ),
      ],
    );
  }
}
