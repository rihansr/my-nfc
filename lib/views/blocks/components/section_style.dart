import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../views/blocks/components/backdrop.dart';
import '../../../utils/extensions.dart';
import '../../../shared/constants.dart';
import '../../../shared/strings.dart';
import '../../../widgets/colour_picker_widget.dart';
import '../../../widgets/seekbar_widget.dart';
import '../../../widgets/tab_widget.dart';
import 'spcaing.dart';

// ignore: must_be_immutable
class SectionStyle extends StatelessWidget {
  final Map<String, dynamic> style;
  final Map<String, dynamic>? settings;
  final Function(Map<String, dynamic>)? onUpdate;

  late Color? _selectedBackgroudColor;
  late String? _selectedVerticalAlignment;
  late String? _selectedHorizontalAlignment;
  late Color? _selectedOverlayColor;
  late int _selectedOverlayOpacity;

  SectionStyle(
    this.style, {
    this.settings,
    super.key,
    this.onUpdate,
  })  : _selectedBackgroudColor =
            style['background']?['color']?.toString().hexColor,
        _selectedVerticalAlignment = style['alignment']?['vertical'],
        _selectedHorizontalAlignment = style['alignment']?['horizontal'],
        _selectedOverlayColor = style['overlay']?['color']?.toString().hexColor,
        _selectedOverlayOpacity = style['overlay']?['opacity'] ?? 0;

  update(String key, MapEntry<String, dynamic> entry) {
    Map<String, dynamic> style = Map<String, dynamic>.from(this.style);
    switch (key) {
      case 'style':
        style.addEntries([entry]);
      default:
        style.addEntry(key, entry);
    }
    onUpdate?.call(style);
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
            colors: kColors,
            onPick: (color) {
              _selectedBackgroudColor = color;
              update('background', MapEntry('color', color.toHex));
            },
          ),
        if (style.containsKey('alignment')) ...[
          TabWidget(
            title: string.contentVerticalAlignment,
            tabs: kVerticalAlignments,
            value: _selectedVerticalAlignment,
            onSelect: (alignment) {
              _selectedVerticalAlignment = alignment;
              update('alignment', MapEntry('vertical', alignment));
            },
          ),
          TabWidget(
            title: string.contentHorizontalAlignment,
            tabs: kHorizontalAlignments,
            value: _selectedHorizontalAlignment,
            onSelect: (alignment) {
              _selectedHorizontalAlignment = alignment;
              update('alignment', MapEntry('horizontal', alignment));
            },
          ),
        ],
        if (style.containsKey('overlay')) ...[
          ColourPicker(
            title: string.overlayColor,
            value: _selectedOverlayColor,
            colors: kColors,
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
        if (style.containsKey('padding') || style.containsKey('margin'))
          Spacing(
            title: string.paddingAndMarginSettings,
            padding: style['padding'],
            margin: style['margin'],
            onUpdate: (spacing) => update('style', spacing),
          ),
        if (settings != null) ...[],
      ],
    );
  }
}
