import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../views/blocks/components.dart';
import '../../models/theme_model.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../widgets/tab_widget.dart';
import '../../widgets/colour_picker_widget.dart';
import '../../widgets/seekbar_widget.dart';
import '../../utils/extensions.dart';
import '../../shared/constants.dart';
import '../../shared/strings.dart';
import '../../widgets/input_field_widget.dart';
import '../../widgets/dropdown_widget.dart';
import 'components/block_expansion_tile.dart';

class TextSettings extends StatelessWidget {
  final String path;
  final Map<String, dynamic>? defaultBlock;
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  const TextSettings({
    super.key,
    required this.path,
    this.defaultBlock,
    required this.block,
    this.onUpdate,
  });

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
    ThemeData theme = Theme.of(context);
    ThemeModel defaultTheme =
        Provider.of<DashboardViewModel>(context, listen: false).theme;

    return BlockExpansionTile.settings(
      block['settings'],
      key: Key('$path/'),
      defaultStyle: defaultBlock?['style'],
      style: block['style'],
      icon: Icons.title,
      label: block['label'],
      enableBorder: true,
      maintainState: true,
      onUpdate: (key, entry) {
        block.addEntry(key, entry);
        onUpdate?.call(block);
      },
      onRemove: () => onUpdate?.call({}),
      padding: const EdgeInsets.fromLTRB(14, 0, 22, 8),
      children: [
        ...(block['subBlock'] == 'text_name'
            ? [
                InputField(
                  controller: TextEditingController(
                      text: block['data']?['name']?['first']),
                  title: string.firstName,
                  keyboardType: TextInputType.name,
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
                  keyboardType: TextInputType.name,
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
                  keyboardType: TextInputType.name,
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
                  keyboardType: TextInputType.multiline,
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
          items: const [null, ...kFontFamilys],
          value: block['data']?['style']?['text']?['typography'],
          selectedItemBuilder: (item) => Text(item ?? string.fromThemeSettings),
          itemBuilder: (item) => Text(
            item ?? string.fromThemeSettings,
            style: item == null
                ? null
                : GoogleFonts.getFont(
                    item,
                    textStyle: Theme.of(context).textTheme.bodySmall,
                  ),
          ),
          onSelected: (String? font) =>
              update('text', MapEntry('typography', font)),
        ),
        Seekbar(
          title: string.fontSize,
          defaultValue: defaultBlock?['data']?['style']?['text']?['fontSize'],
          value: block['data']?['style']?['text']?['fontSize'] ?? 12,
          min: 8,
          max: 96,
          onChanged: (size) => update('text', MapEntry('fontSize', size)),
        ),
        ColourPicker(
          title: string.textColor,
          value: block['data']?['style']?['text']?['textColor']
                  ?.toString()
                  .hexColor ??
              defaultTheme.textColor,
          colors: kColors,
          onPick: (color) => update('text', MapEntry('textColor', color.toHex)),
        ),
        TabWidget(
          title: string.fontWeight,
          tabs: kFontWeights,
          value: block['data']?['style']?['text']?['fontWeight'],
          itemBuilder: (item, isSelected) => Text(
            item,
            style: theme.textTheme.bodySmall?.copyWith(
                color:
                    isSelected ? theme.colorScheme.primary : theme.dividerColor,
                fontWeight: fontWeight(item)),
          ),
          onSelect: (weight) => update('text', MapEntry('fontWeight', weight)),
        ),
        if ((block['data']?['style']?['text'] as Map?)
                ?.containsKey('alignment') ??
            false)
          TabWidget(
            title: string.alignment,
            tabs: kHorizontalAlignments,
            reselectable: true,
            value: block['data']?['style']?['text']?['alignment'],
            onSelect: (alignment) =>
                update('text', MapEntry('alignment', alignment)),
          ),
      ],
    );
  }
}
