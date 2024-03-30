import 'package:flutter/material.dart';
import '../../../shared/strings.dart';
import '../../../widgets/seekbar_widget.dart';
import 'expansion_settings_tile.dart';

// ignore: must_be_immutable
class Spacing extends StatelessWidget {
  final String? title;
  final Map<String, dynamic>? padding;
  final Map<String, dynamic>? margin;
  final Function(MapEntry<String, Map<String, dynamic>>)? onUpdate;

  late final int _horizontalPadding;
  late final int _verticalPadding;
  late final int _leftMargin;
  late final int _topMargin;
  late final int _rightMargin;
  late final int _bottomMargin;

  Spacing({
    super.key,
    this.title,
    this.padding,
    this.margin,
    this.onUpdate,
  })  : _horizontalPadding = padding?['horizontal'] ?? 0,
        _verticalPadding = padding?['vertical'] ?? 0,
        _leftMargin = margin?['left'] ?? 0,
        _topMargin = margin?['top'] ?? 0,
        _rightMargin = margin?['right'] ?? 0,
        _bottomMargin = margin?['bottom'] ?? 0;

  @override
  Widget build(BuildContext context) {
    return ExpansionSettingsTile(
      label: string.paddingAndMarginSettings,
      padding: const EdgeInsets.all(0),
      titlePadding: const EdgeInsets.all(0),
      children: [
        if (padding?.containsKey('horizontal') ?? false)
          Seekbar(
            title: string.horizontalPadding,
            type: 'px',
            defaultValue: 0,
            value: _horizontalPadding,
            onChanged: (val) {
              padding!['horizontal'] = val;
              onUpdate?.call(MapEntry("padding", padding!));
            },
          ),
        if (padding?.containsKey('vertical') ?? false)
          Seekbar(
            title: string.verticalPadding,
            type: 'px',
            defaultValue: 0,
            value: _verticalPadding,
            onChanged: (val) {
              padding!['vertical'] = val;
              onUpdate?.call(MapEntry("padding", padding!));
            },
          ),
        if (margin?.containsKey('top') ?? false)
          Seekbar(
            title: string.topMargin,
            type: 'px',
            defaultValue: 0,
            value: _topMargin,
            onChanged: (val) {
              margin!['top'] = val;
              onUpdate?.call(MapEntry("margin", margin!));
            },
          ),
        if (margin?.containsKey('bottom') ?? false)
          Seekbar(
            title: string.bottomMargin,
            type: 'px',
            defaultValue: 0,
            value: _bottomMargin,
            onChanged: (val) {
              margin!['bottom'] = val;
              onUpdate?.call(MapEntry("margin", margin!));
            },
          ),
        if (margin?.containsKey('left') ?? false)
          Seekbar(
            title: string.leftMargin,
            type: 'px',
            defaultValue: 0,
            value: _leftMargin,
            onChanged: (val) {
              margin!['left'] = val;
              onUpdate?.call(MapEntry("margin", margin!));
            },
          ),
        if (margin?.containsKey('right') ?? false)
          Seekbar(
            title: string.rightMargin,
            type: 'px',
            defaultValue: 0,
            value: _rightMargin,
            onChanged: (val) {
              margin!['right'] = val;
              onUpdate?.call(MapEntry("margin", margin!));
            },
          ),
      ],
    );
  }
}
