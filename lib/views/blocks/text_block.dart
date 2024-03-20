import 'package:flutter/material.dart';
import '../../utils/debug.dart';
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

  late final String? _selectedFonFamily;
  late final int _selectedFontSize;
  late final Color? _selectedFontColor;
  late final String? _selectedFontWeight;
  late final String? _selectedAlignment;

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
            block['data']?['style']?['color']?.toString().color,
        _selectedFontWeight =
            block['data']?['style']?['fontWeight'] ?? 'regular',
        _selectedAlignment = block['data']?['style']?['alignment'] ?? 'left';

  update(MapEntry<String, dynamic> entry) {
    block['datas'] ??= {};
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      block,
      icon: Icons.title,
      padding: const EdgeInsets.fromLTRB(12, 8, 28, 18),
      children: [
        ...(block['block'] == 'name'
            ? [
                InputField(
                  controller: _firstNameController,
                  title: string.firstName,
                  onTyping: (text) {
                    block['data'] ??= <String, dynamic>{};
                    (block['data'] as Map<String, dynamic>).addEntry(
                        'name', MapEntry('first', text.isEmpty ? null : text));
                    onUpdate?.call(block);
                  },
                ),
                InputField(
                  controller: _middleNameController,
                  title: string.middleName,
                  onTyping: (text) {
                    block['data'] ??= <String, dynamic>{};
                    (block['data'] as Map<String, dynamic>).addEntry(
                        'name', MapEntry('middle', text.isEmpty ? null : text));
                    onUpdate?.call(block);
                  },
                ),
                InputField(
                  controller: _lastNameController,
                  title: string.lastName,
                  onTyping: (text) {
                    block['data'] ??= <String, dynamic>{};
                    (block['data'] as Map<String, dynamic>).addEntry(
                        'name', MapEntry('last', text.isEmpty ? null : text));
                    onUpdate?.call(block);
                  },
                ),
              ]
            : [
                InputField(
                  controller: _contentController,
                  minLines: 2,
                  maxLines: 8,
                  title: string.content,
                  onTyping: (text) {
                    block.addEntry('data',
                        MapEntry('content', text.isEmpty ? null : text));
                    onUpdate?.call(block);
                  },
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
            block['data'] ??= <String, dynamic>{};
            (block['data'] as Map<String, dynamic>)
                .addEntry('style', MapEntry('fontFamily', font));
            onUpdate?.call(block);
          },
        ),
        Seekbar(
          title: string.fontSize,
          value: _selectedFontSize,
          min: 8,
          max: 96,
          onUpdate: (size) {
            block['data'] ??= <String, dynamic>{};
            (block['data'] as Map<String, dynamic>)
                .addEntry('style', MapEntry('fontSize', size));
            onUpdate?.call(block);
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
            block['data'] ??= <String, dynamic>{};
            (block['data'] as Map<String, dynamic>)
                .addEntry('style', MapEntry('color', color));
            debug.print(block);
            //onUpdate?.call(block);
          },
        ),
        TabWidget(
            title: string.fontWeight,
            tabs: kFontWeights,
            value: _selectedFontWeight,
            onSelect: (weight) {
              block['data'] ??= <String, dynamic>{};
              (block['data'] as Map<String, dynamic>)
                  .addEntry('style', MapEntry('fontWeight', weight));
              onUpdate?.call(block);
            }),
        TabWidget(
            title: string.alignment,
            tabs: kAlignments,
            value: _selectedAlignment,
            onSelect: (alignment) {
              block['data'] ??= <String, dynamic>{};
              (block['data'] as Map<String, dynamic>)
                  .addEntry('style', MapEntry('alignment', alignment));
              onUpdate?.call(block);
            }),
        Spacing(
          padding: block['data']?['padding'],
          margin: block['data']?['margin'],
          onUpdate: (spacing) {
            block.addEntry('data', spacing);
            onUpdate?.call(block);
          },
        ),
      ],
    );
  }
}
