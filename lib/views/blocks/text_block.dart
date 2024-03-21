import 'package:flutter/material.dart';
import '../../widgets/tab_widget.dart';
import '../../widgets/colour_picker_widget.dart';
import '../../widgets/seekbar_widget.dart';
import '../../utils/extensions.dart';
import '../../shared/constants.dart';
import '../../shared/strings.dart';
import '../../widgets/input_field_widget.dart';
import '../../widgets/dropdown_widget.dart';
import 'components/expansion_block_tile.dart';
import 'components/spcaing.dart';

// ignore: must_be_immutable
class TextBlock extends StatelessWidget {
  final Map<String, dynamic> block;
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

  TextBlock({
    super.key,
    required this.block,
    this.onUpdate,
  })  : _contentController =
            TextEditingController(text: block['data']?['content']),
        _firstNameController =
            TextEditingController(text: block['data']?['name']?['first']),
        _middleNameController =
            TextEditingController(text: block['data']?['name']?['middle']),
        _lastNameController =
            TextEditingController(text: block['data']?['name']?['last']),
        _selectedFonFamily = block['data']?['style']?['fontFamily'],
        _selectedFontSize = block['data']?['style']?['fontSize'] ?? 12,
        _selectedFontColor =
            block['data']?['style']?['color']?.toString().hexColor,
        _selectedFontWeight =
            block['data']?['style']?['fontWeight'] ?? 'regular',
        _selectedAlignment = block['data']?['style']?['alignment'] ?? 'left';

  updateBlock(String key, MapEntry<String, dynamic> value) {
    switch (key) {
      case 'data':
        block.addEntry(key, value);
      default:
        block['data'] ??= {};
        (block['data'] as Map<String, dynamic>).addEntry(key, value);
    }
    onUpdate?.call(block);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      block,
      maintainState: true,
      icon: Icons.title,
      padding: const EdgeInsets.fromLTRB(12, 8, 28, 18),
      children: [
        ...(block['block'] == 'name'
            ? [
                InputField(
                  controller: _firstNameController,
                  title: string.firstName,
                  onTyping: (text) => updateBlock(
                    'name',
                    MapEntry('first', text.isEmpty ? null : text),
                  ),
                ),
                InputField(
                  controller: _middleNameController,
                  title: string.middleName,
                  onTyping: (text) => updateBlock(
                    'name',
                    MapEntry('middle', text.isEmpty ? null : text),
                  ),
                ),
                InputField(
                  controller: _lastNameController,
                  title: string.lastName,
                  onTyping: (text) => updateBlock(
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
                  onTyping: (text) => updateBlock(
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
            updateBlock('style', MapEntry('fontFamily', font));
          },
        ),
        Seekbar(
          title: string.fontSize,
          value: _selectedFontSize,
          min: 8,
          max: 96,
          onChanged: (size) {
            _selectedFontSize = size;
            updateBlock('style', MapEntry('fontSize', size));
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
            updateBlock('style', MapEntry('color', color.toHex));
          },
        ),
        TabWidget(
            title: string.fontWeight,
            tabs: kFontWeights,
            value: _selectedFontWeight,
            onSelect: (weight) {
              _selectedFontWeight = weight;
              updateBlock('style', MapEntry('fontWeight', weight));
            }),
        TabWidget(
            title: string.alignment,
            tabs: kAlignments,
            value: _selectedAlignment,
            onSelect: (alignment) {
              _selectedAlignment = alignment;
              updateBlock('style', MapEntry('alignment', alignment));
            }),
        Spacing(
          padding: block['data']?['padding'],
          margin: block['data']?['margin'],
          onUpdate: (spacing) => updateBlock('data', spacing),
        ),
      ],
    );
  }
}
