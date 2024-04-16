import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:provider/provider.dart';
import '../shared/drawables.dart';
import '../shared/strings.dart';
import 'clipper_widget.dart';

class ColourPicker extends StatelessWidget {
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
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title?.trim().isNotEmpty ?? false)
            Padding(
              padding: titleSpacing,
              child: Text(
                title ?? '',
                textAlign: titleAlign,
                style: titleStyle ??
                    theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ChangeNotifierProvider<_ColourViewModel>.value(
            value: _ColourViewModel(colors, reselectable, value),
            child: Consumer<_ColourViewModel>(
              builder: (context, controller, _) => Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  ...colors.map(
                    (color) => _ColorItem(
                      isSelected: controller.isColorSelected(color),
                      color: color,
                      onTap: (color) {
                        controller.select = color;
                        onPick?.call(color);
                      },
                    ),
                  ),
                  _ColorItem(
                    isSelected: controller.isColorPicked,
                    color: controller.pickerColor,
                    child: const Icon(
                      Iconsax.brush_4,
                      size: 16,
                      color: Colors.black,
                    ),
                    onTap: (_) => ColorPicker(
                      color: controller.pickerColor,
                      onColorChanged: (Color color) {
                        controller.pick = color;
                        onPick?.call(color);
                      },
                      width: 40,
                      height: 40,
                      borderRadius: 4,
                      spacing: 5,
                      runSpacing: 5,
                      wheelDiameter: 155,
                      heading: Text(
                        string.selectColor,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subheading: Text(
                        string.selectColorShade,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      wheelSubheading: Text(
                        string.selectedColor,
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
                      colorCodeTextStyle:
                          Theme.of(context).textTheme.bodyMedium,
                      colorCodePrefixStyle:
                          Theme.of(context).textTheme.bodySmall,
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
                    ),
                  ),
                ],
              ),
            ),
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
      radius: 36,
      highlightColor: color.withOpacity(0.25),
      onTap: () => onTap?.call(color),
      child: Clipper.circle(
        backdrop: color == Colors.transparent
            ? DecorationImage(
                image: AssetImage(drawable.transparentBG),
                fit: BoxFit.fill,
              )
            : null,
        border: Border.all(
          color: isSelected ? theme.primaryColor : theme.disabledColor,
          width: 2,
          strokeAlign: isSelected
              ? BorderSide.strokeAlignOutside
              : BorderSide.strokeAlignInside,
        ),
        size: 36,
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(1.5),
        child: CircleAvatar(
          backgroundColor: color,
          child: child,
        ),
      ),
    );
  }
}

class _ColourViewModel extends ChangeNotifier {
  late final bool _reselectable;
  late bool _chooseFromPicker;
  late Color? _selectedColor;
  late Color _pickerColor;

  _ColourViewModel(List<Color> colors, this._reselectable, [Color? color])
      : _chooseFromPicker = !(color == null || colors.contains(color)),
        _selectedColor = color,
        _pickerColor =
            color == null || colors.contains(color) ? Colors.white : color;

  bool get chooseFromPicker => _chooseFromPicker;

  Color? get selectedColor => _selectedColor;

  Color get pickerColor => _pickerColor;

  bool isColorSelected(Color color) =>
      !_chooseFromPicker && (_selectedColor == color);

  bool get isColorPicked =>
      _chooseFromPicker && (_selectedColor == _pickerColor);

  set select(Color color) {
    _chooseFromPicker = false;
    if (_reselectable) {
      _selectedColor = _selectedColor == color ? null : color;
    } else if (_selectedColor == color) {
    } else {
      _selectedColor = color;
    }
    notifyListeners();
  }

  set pick(Color color) => this
    .._chooseFromPicker = true
    .._pickerColor = color
    .._selectedColor = color
    ..notifyListeners();
}
