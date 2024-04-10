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

// ignore: must_be_immutable
class BlockStyle extends StatelessWidget {
  final Map<String, dynamic> style;
  final Map<String, dynamic>? settings;
  final Function(Map<String, dynamic>)? onUpdate;
  final Function(Map<String, dynamic>)? onSettingsUpdate;

  late Color? _selectedBackgroudColor;
  late Color? _selectedOverlayColor;
  late int _selectedOverlayOpacity;
  late bool _fullWidth;
  late bool _openInNewTab;

  BlockStyle(
    this.style, {
    this.settings,
    super.key,
    this.onUpdate,
    this.onSettingsUpdate,
  })  : _selectedBackgroudColor =
            style['background']?['color']?.toString().hexColor,
        _selectedOverlayColor = style['overlay']?['color']?.toString().hexColor,
        _selectedOverlayOpacity = style['overlay']?['opacity'] ?? 0,
        _fullWidth = style['fullWidth'] ?? true,
        _openInNewTab = settings?['openInNewTab'] ?? true;

  update(String key, MapEntry<String, dynamic> entry) {
    Map<String, dynamic> style = Map<String, dynamic>.from(this.style);
    switch (key) {
      case 'settings':
        settings?.addEntries([entry]);
        onSettingsUpdate?.call(settings!);
      case 'style':
        style.addEntries([entry]);
        onUpdate?.call(style);

      default:
        style.addEntry(key, entry);
        onUpdate?.call(style);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if ((style['background'] as Map?)?.containsKey('image') ?? false)
          Backdrop(
            style['background']?['image'] ?? {},
            onUpdate: (map) {
              style['background']?['image'] = map;
              onUpdate?.call(style);
            },
          ),
        if ((style['background'] as Map?)?.containsKey('color') ?? false)
          ColourPicker(
            title: string.backgroundColor,
            value: _selectedBackgroudColor,
            colors: const [Colors.transparent],
            onPick: (color) {
              _selectedBackgroudColor = color;
              update('background', MapEntry('color', color.toHex));
            },
          ),
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
                      value: entry.value,
                      onSelect: (alignment) {
                        update('alignment', MapEntry(entry.key, alignment));
                      },
                    ))
                .toList() ??
            [],
        if (style.containsKey('overlay')) ...[
          ColourPicker(
            title: string.overlayColor,
            value: _selectedOverlayColor,
            colors: const [Colors.transparent, Colors.black, Colors.white],
            onPick: (color) {
              _selectedOverlayColor = color;
              update('overlay', MapEntry('color', color.toHex));
            },
          ),
          Seekbar(
            title: string.overlayOpacity,
            value: _selectedOverlayOpacity,
            type: '%',
            min: 0,
            max: 100,
            onChanged: (opacity) {
              _selectedOverlayOpacity = opacity;
              update('overlay', MapEntry('opacity', opacity));
            },
          ),
        ],
        if (style.containsKey('fullWidth'))
          CheckboxWidget.expand(
            value: _fullWidth,
            label: string.fullWidth,
            onChanged: (checked) {
              _fullWidth = checked;
              update('style', MapEntry('fullWidth', checked));
            },
          ),
        if (style.containsKey('spacing'))
          Spacing(
            title: string.paddingAndMarginSettings,
            spacing: style['spacing'],
            onUpdate: (spacing) => update('style', spacing),
          ),
        if (settings != null) ...[
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
                  onTyping: (text) => update(
                    'settings',
                    MapEntry('linkTo', text.isEmpty ? null : text),
                  ),
                ),
              if (settings!.containsKey('openInNewTab'))
                CheckboxWidget.expand(
                  value: _openInNewTab,
                  label: string.openInNewTab,
                  onChanged: (checked) {
                    _openInNewTab = checked;
                    update('settings', MapEntry('openInNewTab', checked));
                  },
                ),
            ],
          ),
        ],
      ],
    );
  }
}
