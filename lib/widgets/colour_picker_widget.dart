import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:iconsax/iconsax.dart';
import '../shared/drawables.dart';
import 'clipper_widget.dart';

class ColourPicker extends StatefulWidget {
  final String? title;
  final TextStyle? titleStyle;
  final TextAlign titleAlign;
  final EdgeInsets titleSpacing;
  final EdgeInsets margin;
  final List<Color> colors;
  final Color? value;
  final bool reselectable;
  final Function(Color)? onPick;

  const ColourPicker({
    super.key,
    this.title,
    this.titleStyle,
    this.titleAlign = TextAlign.start,
    this.titleSpacing = const EdgeInsets.only(bottom: 10),
    this.margin = const EdgeInsets.symmetric(vertical: 12),
    this.colors = const [],
    this.value,
    this.reselectable = false,
    this.onPick,
  });

  @override
  State<ColourPicker> createState() => _ColourPickerState();
}

class _ColourPickerState extends State<ColourPicker> {
  late bool _chooseFromPicker;
  late Color? _selectedColor;
  late Color _pickerColor;

  @override
  void initState() {
    _chooseFromPicker = false;
    _selectedColor = widget.value;
    _pickerColor = Colors.white;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title?.trim().isNotEmpty ?? false)
            Padding(
              padding: widget.titleSpacing,
              child: Text(
                widget.title ?? '',
                textAlign: widget.titleAlign,
                style: widget.titleStyle ??
                    theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...widget.colors.map(
                (color) => _ColorItem(
                  isSelected: !_chooseFromPicker && (_selectedColor == color),
                  color: color,
                  onTap: (color) {
                    _chooseFromPicker = false;
                    if (widget.reselectable) {
                      _selectedColor = _selectedColor == color ? null : color;
                    } else if (_selectedColor == color) {
                      setState(() {});
                      return;
                    } else {
                      _selectedColor = color;
                    }
                    setState(() {});
                    widget.onPick?.call(color);
                  },
                ),
              ),
              _ColorItem(
                isSelected:
                    _chooseFromPicker && (_selectedColor == _pickerColor),
                color: _pickerColor,
                child: const Icon(
                  Iconsax.brush_4,
                  size: 16,
                  color: Colors.black,
                ),
                /*
                  onTap: (_) async {
                    ColorPicker(
                    color: _pickerColor,
                    onColorChanged: (Color color) {
                      setState(
                        () => this
                          .._chooseFromPicker = true
                          .._pickerColor = color
                          .._selectedColor = color,
                      );
                      widget.onPick?.call(color);
                    },
                    width: 40,
                    height: 40,
                    borderRadius: 4,
                    spacing: 5,
                    runSpacing: 5,
                    wheelDiameter: 155,
                    heading: Text(
                      'Select color',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subheading: Text(
                      'Select color shade',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    wheelSubheading: Text(
                      'Selected color and its shades',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    showColorName: true,
                    showColorCode: true,
                    showRecentColors: true,
                    elevation: 0.5,
                    enableOpacity: true,
                    selectedColorIcon: Iconsax.brush_4,
                    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                      copyButton: true,
                      pasteButton: true,
                      longPressMenu: true,
                    ),
                    materialNameTextStyle:
                        Theme.of(context).textTheme.bodySmall,
                    colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
                    colorCodeTextStyle: Theme.of(context).textTheme.bodyMedium,
                    colorCodePrefixStyle: Theme.of(context).textTheme.bodySmall,
                    selectedPickerTypeColor:
                        Theme.of(context).colorScheme.primary,
                    pickersEnabled: const <ColorPickerType, bool>{
                      ColorPickerType.both: true,
                      ColorPickerType.primary: false,
                      ColorPickerType.accent: false,
                      ColorPickerType.bw: true,
                      ColorPickerType.custom: false,
                      ColorPickerType.wheel: true,
                    },
                  ).showPickerDialog(
                    context,
                    actionsPadding: const EdgeInsets.all(16),
                    constraints: const BoxConstraints(
                        minHeight: 480, minWidth: 300, maxWidth: 320),
                  );
                },
                */
                onTap: (_) => showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    contentPadding: const EdgeInsets.only(top: 18),
                    insetPadding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    children: [
                      ColorPicker(
                        pickerColor: _pickerColor,
                        onColorChanged: (color) {
                          setState(
                            () => this
                              .._chooseFromPicker = true
                              .._pickerColor = color
                              .._selectedColor = color,
                          );
                          widget.onPick?.call(color);
                        },
                        hexInputBar: true,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ColorItem extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final Widget? child;
  final Function(Color)? onTap;
  const _ColorItem({
    required this.color,
    this.isSelected = false,
    this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return InkWell(
      radius: 34,
      highlightColor: color.withOpacity(0.25),
      onTap: () => onTap?.call(color),
      child: Clipper(
        shape: BoxShape.circle,
        backdrop: color == Colors.transparent
            ? DecorationImage(
                image: AssetImage(drawable.transparentBG),
                fit: BoxFit.fill,
              )
            : null,
        border: Border.all(
          color: isSelected
              ? color == theme.colorScheme.tertiary
                  ? theme.primaryColor
                  : theme.colorScheme.tertiary
              : Colors.grey,
          width: isSelected ? 2 : 1,
        ),
        size: 34,
        color: color,
        child: child,
      ),
    );
  }
}
