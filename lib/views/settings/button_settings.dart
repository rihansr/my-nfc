import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/theme_model.dart';
import '../../shared/constants.dart';
import '../../utils/extensions.dart';
import '../../shared/strings.dart';
import '../../viewmodels/design_viewmodel.dart';
import '../../widgets/checkbox_widget.dart';
import '../../widgets/colour_picker_widget.dart';
import '../../widgets/dropdown_widget.dart';
import '../../widgets/input_field_widget.dart';
import '../../widgets/seekbar_widget.dart';
import '../../widgets/tab_widget.dart';
import 'components/block_expansion_tile.dart';
import 'components/spcaing.dart';

class ButtonSettings extends StatelessWidget {
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  const ButtonSettings({
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
    ThemeModel defaultTheme = Provider.of<DesignViewModel>(context, listen: false).theme;
    return BlockExpansionTile.settings(
      block['settings'],
      key: Key('$key'),
      icon: Icons.add_circle_outline,
      label: block['label'],
      enableBorder: true,
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
        BlockExpansionTile(
          label: string.buttonDesign,
          children: [
            ColourPicker(
              title: string.borderCcolor,
              value: block['style']?['border']?['borderColor']?.toString().hexColor ?? defaultTheme.iconColor,
              colors: const [Colors.transparent, ...kColors],
              onPick: (color) => update('border', MapEntry('color', color.toHex)),
            ),
            Seekbar(
              title: string.borderThickness,
              type: 'px',
              value: block['style']?['border']?['thickness'] ?? 1,
              min: 0,
              max: 100,
              onChanged: (size) => update('border', MapEntry('thickness', size)),
            ),
            Seekbar(
              title: string.borderRadius,
              type: 'px',
              value: block['style']?['border']?['radius'] ?? 4,
              min: 0,
              max: 50,
              onChanged: (radius) => update('border', MapEntry('radius', radius)),
            ),
            CheckboxWidget.expand(
              value: block['style']?['fullWidth'] ?? false,
              label: string.fullWidth,
              onChanged: (checked) => update('style', MapEntry('fullWidth', checked)),
            ),
            Dropdown<String?>(
              title: string.typography,
              hint: string.selectOne,
              items: const [null, ...kFontFamilys],
              value: block['data']?['style']?['text']?['typography'],
              maintainState: true,
              itemBuilder: (p0) =>
                  Text(p0?.replaceAll('_', ' ') ?? string.fromThemeSettings),
              onSelected: (String? font) => update('text', MapEntry('typography', font)),
            ),
            Seekbar(
              title: string.fontSize,
              value: block['data']?['style']?['text']?['fontSize'] ?? 16,
              min: 8,
              max: 96,
              onChanged: (size) => update('text', MapEntry('fontSize', size)),
            ),
            ColourPicker(
              title: string.textColor,
              value: block['data']?['style']?['text']?['textColor']?.toString().hexColor ?? defaultTheme.iconColor,
              colors: kColors,
              onPick: (color) => update('text', MapEntry('textColor', color.toHex)),
            ),
            TabWidget(
              title: string.fontWeight,
              tabs: kFontWeights,
              value: block['data']?['style']?['text']?['fontWeight'] ?? 'regular',
              onSelect: (weight) => update('text', MapEntry('fontWeight', weight)),
            ),
            CheckboxWidget.expand(
              value: block['settings']?['additional']?['openInNewTab'] ?? true,
              label: string.fullWidth,
              onChanged: (checked) => update('additional', MapEntry('openInNewTab', checked)),
            ),
            CheckboxWidget.expand(
              value: block['settings']?['additional']?['disabled'] ?? false,
              label: string.disabled,
              onChanged: (checked) => update('additional', MapEntry('disabled', checked)),
            ),
          ],
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
