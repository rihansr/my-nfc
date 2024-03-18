import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../widgets/clipper_widget.dart';
import '../../widgets/seekbar_widget.dart';
import '../../utils/extensions.dart';
import '../../shared/constants.dart';
import '../../shared/strings.dart';
import '../../widgets/input_field_widget.dart';
import '../../widgets/dropdown_widget.dart';
import 'components/expansion_block_tile.dart';

class TextBlock extends StatefulWidget {
  final MapEntry<Object, Map<String, dynamic>> data;
  const TextBlock({super.key, required this.data});

  @override
  State<TextBlock> createState() => _TextBlockState();
}

class _TextBlockState extends State<TextBlock> {
  late TextEditingController _contentController;
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;

  late List<Color> pickerColors;
  late Color pickerColor;
  late String? selectedFonFamily;
  late int selectedFontSize;
  late Color? selectedFontColor;

  @override
  void initState() {
    _contentController =
        TextEditingController(text: widget.data.value['content']);
    _firstNameController =
        TextEditingController(text: widget.data.value['name']?['first']);
    _middleNameController =
        TextEditingController(text: widget.data.value['name']?['middle']);
    _lastNameController =
        TextEditingController(text: widget.data.value['name']?['last']);
    pickerColors = [
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
      Colors.brown,
      Colors.white,
    ];
    pickerColor = Colors.white;

    selectedFonFamily = widget.data.value['data']?['style']?['fontFamily'];
    selectedFontSize = widget.data.value['data']?['style']?['fontSize'] ?? 12;
    selectedFontColor =
        widget.data.value['data']?['style']?['color']?.toString().color;
    super.initState();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ExpansionBlockTile(
      widget.data.value,
      icon: Icons.title,
      padding: const EdgeInsets.fromLTRB(12, 8, 28, 18),
      children: [
        ...(widget.data.value['block'] == 'name'
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
          value: selectedFonFamily,
          title: string.typography,
          hint: string.selectOne,
          items: [null, ...kFontFamilys],
          itemBuilder: (p0) =>
              Text(p0?.replaceAll('_', ' ') ?? string.fromThemeSettings),
          onSelected: (String? value) =>
              setState(() => selectedFonFamily = value),
        ),
        Seekbar(
          title: string.fontSize(selectedFontSize),
          value: selectedFontSize,
          min: 8,
          max: 96,
          onUpdate: (value) => setState(() => selectedFontSize = value),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: pickerColors
              .mapIndexed(
                (i, color) => InkWell(
                  onTap: i != pickerColors.length - 1
                      ? () => setState(() => selectedFontColor = color)
                      : () => showDialog(
                            context: context,
                            builder: (context) => SimpleDialog(
                              contentPadding: const EdgeInsets.only(top: 18),
                              insetPadding: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              children: [
                                ColorPicker(
                                  pickerColor: pickerColor,
                                  onColorChanged: (color) => setState(() {
                                    pickerColor = color;
                                    selectedFontColor = color;
                                  }),
                                  pickerAreaHeightPercent: 0.8,
                                ),
                              ],
                            ),
                          ),
                  child: Clipper(
                    shape: BoxShape.circle,
                    border: color == selectedFontColor ||
                            (i == pickerColors.length - 1 &&
                                pickerColor == selectedFontColor)
                        ? Border.all(
                            color: theme.colorScheme.tertiary,
                            width: 2,
                          )
                        : null,
                    color: i != pickerColors.length - 1 ? color : pickerColor,
                    size: 32,
                    child: i != pickerColors.length - 1
                        ? null
                        : const Icon(Icons.edit, size: 16),
                  ),
                ),
              )
              .toList(),
        ),
        ListTile(
          title: Text(
            string.textColor,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: CircleAvatar(
            backgroundColor: selectedFontColor,
            radius: 15,
          ),
          onTap: () => showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              contentPadding: const EdgeInsets.only(top: 18),
              insetPadding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              children: [
                ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (color) => setState(() {
                    pickerColor = color;
                    selectedFontColor = color;
                  }),
                  pickerAreaHeightPercent: 0.8,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
