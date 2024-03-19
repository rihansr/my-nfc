import 'package:flutter/material.dart';
import 'package:my_nfc/utils/debug.dart';
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
  final MapEntry<Object, Map<String, dynamic>> data;

  final TextEditingController _contentController;
  final TextEditingController _firstNameController;
  final TextEditingController _middleNameController;
  final TextEditingController _lastNameController;

  late String? _selectedFonFamily;
  late int _selectedFontSize;
  late final Color? _selectedFontColor;
  late final String? _selectedFontWeight;
  late final String? _selectedAlignment;

  TextBlock({super.key, required this.data})
      : _contentController = TextEditingController(text: data.value['content']),
        _firstNameController =
            TextEditingController(text: data.value['name']?['first']),
        _middleNameController =
            TextEditingController(text: data.value['name']?['middle']),
        _lastNameController =
            TextEditingController(text: data.value['name']?['last']),
        _selectedFonFamily = data.value['data']?['style']?['fontFamily'],
        _selectedFontSize = data.value['data']?['style']?['fontSize'] ?? 12,
        _selectedFontColor =
            data.value['data']?['style']?['color']?.toString().color,
        _selectedFontWeight =
            data.value['data']?['style']?['fotWeight'] ?? 'regular',
        _selectedAlignment =
            data.value['data']?['style']?['alignment'] ?? 'left';

  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      data.value,
      icon: Icons.title,
      padding: const EdgeInsets.fromLTRB(12, 8, 28, 18),
      children: [
        ...(data.value['block'] == 'name'
            ? [
                InputField(
                  controller: _firstNameController,
                  title: string.firstName,
                ),
                InputField(
                  controller: _middleNameController,
                  title: string.middleName,
                ),
                InputField(
                  controller: _lastNameController,
                  title: string.lastName,
                ),
              ]
            : [
                InputField(
                  controller: _contentController,
                  minLines: 2,
                  maxLines: 8,
                  title: string.content,
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
          onSelected: (String? value) => _selectedFonFamily = value,
        ),
        Seekbar(
          title: string.fontSize,
          value: _selectedFontSize,
          min: 8,
          max: 96,
          onUpdate: (value) => _selectedFontSize = value,
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
        ),
        TabWidget(
          title: string.fontWeight,
          tabs: kFontWeights,
          value: _selectedFontWeight,
        ),
        TabWidget(
          title: string.alignment,
          tabs: kAlignments,
          value: _selectedAlignment,
        ),
        Spacing(
          padding: data.value['data']?['padding'],
          margin: data.value['data']?['margin'],
          onUpdate: (p0) => debug.print(p0, tag: 'SPACING'),
        ),
      ],
    );
  }
}
