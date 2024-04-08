import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/theme_model.dart';
import '../../viewmodels/design_viewmodel.dart';
import '../../widgets/tab_widget.dart';
import '../../widgets/colour_picker_widget.dart';
import '../../widgets/seekbar_widget.dart';
import '../../utils/extensions.dart';
import '../../shared/constants.dart';
import '../../shared/strings.dart';
import '../../widgets/input_field_widget.dart';
import '../../widgets/dropdown_widget.dart';
import 'components/block_expansion_tile.dart';
import 'components/spcaing.dart';

class TextSettings extends StatelessWidget {
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  const TextSettings({
    super.key,
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
    ThemeModel defaultTheme =
        Provider.of<DesignViewModel>(context, listen: false).theme;
    return BlockExpansionTile.settings(
      block['settings'],
      key: Key('$key'),
      icon: Icons.title,
      label: block['label'],
      enableBorder: true,
      maintainState: true,
      onUpdate: (entry) {
        block.addEntry('settings', entry);
        onUpdate?.call(block);
      },
      onRemove: () => onUpdate?.call({}),
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
          items: const [null, ...kFontFamilys],
          value: block['data']?['style']?['text']?['typography'],
          maintainState: true,
          itemBuilder: (item) => Text(item ?? string.fromThemeSettings),
          onSelected: (String? font) =>
              update('text', MapEntry('typography', font)),
        ),
        Seekbar(
          title: string.fontSize,
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
          onSelect: (weight) => update('text', MapEntry('fontWeight', weight)),
        ),
        if ((block['data']?['style']?['text'] as Map?)?.containsKey('alignment') ?? false)
          TabWidget(
            title: string.alignment,
            tabs: kHorizontalAlignments,
            reselectable: true,
            value: block['data']?['style']?['text']?['alignment'],
            onSelect: (alignment) =>
                update('text', MapEntry('alignment', alignment)),
          ),
        Spacing(
          title: string.paddingAndMarginSettings,
          spacing: block['style']?['spacing'],
          onUpdate: (spacing) => update('style', spacing),
        ),
      ],
    );
  }
}
