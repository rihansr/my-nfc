import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/extensions.dart';
import '../../../shared/constants.dart';
import '../../../shared/strings.dart';
import '../../../widgets/checkbox_widget.dart';
import '../../../widgets/colour_picker_widget.dart';
import '../../../widgets/input_field_widget.dart';
import '../../../widgets/seekbar_widget.dart';
import '../../../widgets/tab_widget.dart';
import 'block_expansion_tile.dart';
import 'backdrop.dart';
import 'spcaing.dart';

class BlockStyle extends StatelessWidget {
  final Map<String, dynamic>? defaultStyle;
  final Map<String, dynamic> style;
  final Function(MapEntry<String, dynamic>)? onUpdate;

  final Map<String, dynamic>? settings;
  final Function(Map<String, dynamic>)? onSettingsUpdate;

  const BlockStyle(
    this.style, {
    this.defaultStyle,
    this.settings,
    super.key,
    this.onUpdate,
    this.onSettingsUpdate,
  });

  update(String key, MapEntry<String, dynamic> entry) {
    Map<String, dynamic> style = Map<String, dynamic>.from(this.style);
    switch (key) {
      case 'settings':
        settings?.addEntries([entry]);
        onSettingsUpdate?.call(settings!);
      case 'style':
        style.addEntries([entry]);
        onUpdate?.call(entry);
      default:
        style.addEntry(key, entry);
        onUpdate?.call(MapEntry(key, Map<String, dynamic>.from(style[key])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (style.containsKey('background'))
          ...(() {
            final background = Map<String, dynamic>.from(style['background']);
            return [
              if (background.containsKey('image'))
                Backdrop(
                  style['background']['image'] ?? {},
                  onUpdate: (map) {
                    background.addEntries([MapEntry('image', map)]);
                    update('style', MapEntry('background', background));
                  },
                ),
              if (background.containsKey('color'))
                ColourPicker(
                  title: string.backgroundColor,
                  value: style['background']['color']?.toString().hexColor,
                  colors: const [Colors.transparent],
                  reselectable: true,
                  onPick: (color) {
                    background.addEntries([MapEntry('color', color.toHex)]);
                    update('style', MapEntry('background', background));
                  },
                ),
            ];
          }()),
        ...(style['alignment'] as Map?)
                ?.entries
                .map((entry) => TabWidget(
                      title: '${entry.key} ${string.alignment}'
                          .capitalizeFirstOfEach,
                      tabs: (() {
                        switch (entry.key) {
                          case 'horizontal':
                            return kHorizontalAlignments;
                          case 'vertical':
                            return kVerticalAlignments;
                          default:
                            return List<String>.from([]);
                        }
                      }()),
                      reselectable: true,
                      value: entry.value,
                      onSelect: (alignment) {
                        update('alignment', MapEntry(entry.key, alignment));
                      },
                    ))
                .toList() ??
            [],
        if (style.containsKey('overlay'))
          ...(() {
            final overlay = Map<String, dynamic>.from(style['overlay']);
            return [
              ColourPicker(
                title: string.overlayColor,
                value: overlay['color']?.toString().hexColor,
                colors: const [Colors.transparent, Colors.black, Colors.white],
                onPick: (color) {
                  overlay.addEntries([MapEntry('color', color.toHex)]);
                  update('style', MapEntry('overlay', overlay));
                },
              ),
              Seekbar(
                title: string.overlayOpacity,
                defaultValue: defaultStyle?['overlay']?['opacity'] ?? 0,
                value: overlay['opacity'] ?? 0,
                type: '%',
                min: 0,
                max: 100,
                onChanged: (opacity) {
                  overlay.addEntries([MapEntry('opacity', opacity)]);
                  update('style', MapEntry('overlay', overlay));
                },
              ),
            ];
          }()),
        if (style.containsKey('fullWidth'))
          CheckboxWidget.expand(
            value: style['fullWidth'] ?? true,
            label: string.fullWidth,
            onChanged: (checked) =>
                update('style', MapEntry('fullWidth', checked)),
          ),
        if (settings != null)
          BlockExpansionTile(
            label: string.advancedSettings,
            children: [
              if (settings!.containsKey('linkTo'))
                InputField(
                  controller: TextEditingController(text: settings?['linkTo']),
                  title: string.linkTo,
                  keyboardType: TextInputType.url,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp(r'\s'),
                      replacementString: '/',
                    ),
                  ],
                  onTyping: (text) {
                    text = text.trim();
                    if (text.isNotEmpty && !text.isValidUrl) return;
                    update(
                      'data',
                      MapEntry('linkTo', text.isEmpty ? null : text),
                    );
                  },
                ),
              if (settings!.containsKey('openInNewTab'))
                CheckboxWidget.expand(
                  value: settings?['openInNewTab'] ?? true,
                  label: string.openInNewTab,
                  onChanged: (checked) =>
                      update('settings', MapEntry('openInNewTab', checked)),
                ),
            ],
          ),
        if (style.containsKey('spacing'))
          Spacing(
            title: string.paddingAndMarginSettings,
            defaultSpacing: defaultStyle?['spacing'],
            spacing: style['spacing'],
            onUpdate: (spacing) => update('style', spacing),
          ),
      ],
    );
  }
}
