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
                    setState(
                      () => this
                        .._chooseFromPicker = false
                        .._selectedColor = color,
                    );
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
