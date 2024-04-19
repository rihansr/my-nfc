import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
import '../blocks/components.dart';
import 'components/block_expansion_tile.dart';

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
      case 'text':
      case 'background':
      case 'border':
        settings['data'] ??= {};
        settings['data']['style'] ??= {};
        (settings['data']['style'] as Map<String, dynamic>)
            .addEntry(key, value);
      case 'advanced':
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
    ThemeData theme = Theme.of(context);
    ThemeModel defaultTheme =
        Provider.of<DesignViewModel>(context, listen: false).theme;
    return BlockExpansionTile.settings(
      block['settings'],
      key: Key('$key'),
      style: block['style'],
      icon: Icons.add_circle_outline,
      label: block['label'],
      enableBorder: true,
      onUpdate: (key, entry) {
        block.addEntry(key, entry);
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
          keyboardType: TextInputType.url,
          inputFormatters: [
            FilteringTextInputFormatter.deny(
              RegExp(r'\s'),
              replacementString: '/',
            ),
          ],
          onTyping: (text) => update(
            'data',
            MapEntry('link', text.isEmpty ? null : text),
          ),
        ),
        BlockExpansionTile(
          label: string.buttonDesign,
          children: [
            ColourPicker(
              title: string.borderColor,
              value: block['data']?['style']?['border']?['borderColor']
                      ?.toString()
                      .hexColor ??
                  defaultTheme.iconColor,
              colors: const [Colors.transparent, ...kColors],
              onPick: (color) =>
                  update('border', MapEntry('borderColor', color.toHex)),
            ),
            Seekbar(
              title: string.borderThickness,
              type: 'px',
              value: block['data']?['style']?['border']?['borderWidth'] ?? 1,
              min: 0,
              max: 100,
              onChanged: (size) =>
                  update('border', MapEntry('borderWidth', size)),
            ),
            Seekbar(
              title: string.borderRadius,
              type: 'px',
              value: block['data']?['style']?['border']?['borderRadius'] ?? 4,
              min: 0,
              max: 50,
              onChanged: (radius) =>
                  update('border', MapEntry('borderRadius', radius)),
            ),
            ColourPicker(
              title: string.buttonColor,
              value: block['data']?['style']?['background']?['color']
                  ?.toString()
                  .hexColor,
              colors: const [Colors.transparent, ...kColors],
              onPick: (color) =>
                  update('background', MapEntry('color', color.toHex)),
            ),
            Dropdown<String?>(
              title: string.typography,
              hint: string.selectOne,
              items: const [null, ...kFontFamilys],
              value: block['data']?['style']?['text']?['typography'],
              selectedItemBuilder: (item) =>
                  Text(item ?? string.fromThemeSettings),
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
              value: block['data']?['style']?['text']?['fontSize'] ?? 16,
              min: 8,
              max: 96,
              onChanged: (size) => update('text', MapEntry('fontSize', size)),
            ),
            ColourPicker(
              title: string.textColor,
              value: block['data']?['style']?['text']?['textColor']
                      ?.toString()
                      .hexColor ??
                  defaultTheme.iconColor,
              colors: kColors,
              onPick: (color) =>
                  update('text', MapEntry('textColor', color.toHex)),
            ),
            TabWidget(
              title: string.fontWeight,
              tabs: kFontWeights,
              value:
                  block['data']?['style']?['text']?['fontWeight'] ?? 'regular',
              itemBuilder: (item, isSelected) => Text(
                item,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.dividerColor,
                    fontWeight: fontWeight(item)),
              ),
              onSelect: (weight) =>
                  update('text', MapEntry('fontWeight', weight)),
            ),
            CheckboxWidget.expand(
              value: block['style']?['fullWidth'] ?? false,
              label: string.fullWidth,
              onChanged: (checked) =>
                  update('style', MapEntry('fullWidth', checked)),
            ),
            CheckboxWidget.expand(
              value: block['settings']?['advanced']?['openInNewTab'] ?? true,
              label: string.openInNewTab,
              onChanged: (checked) =>
                  update('advanced', MapEntry('openInNewTab', checked)),
            ),
            CheckboxWidget.expand(
              value: block['settings']?['advanced']?['disabled'] ?? false,
              label: string.disabled,
              onChanged: (checked) =>
                  update('advanced', MapEntry('disabled', checked)),
            ),
          ],
        ),
      ],
    );
  }
}
