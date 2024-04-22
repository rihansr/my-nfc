import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../shared/styles.dart';
import 'clipper_widget.dart';

class GradientPicker extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final TextAlign titleAlign;
  final EdgeInsets titleSpacing;
  final EdgeInsets margin;
  final List<Gradient> gradientColors;
  final Gradient? value;
  final bool reselectable;
  final Function(Gradient)? onPick;

  const GradientPicker({
    super.key,
    this.title,
    this.titleStyle,
    this.titleAlign = TextAlign.start,
    this.titleSpacing = const EdgeInsets.only(bottom: 10),
    this.margin = const EdgeInsets.symmetric(vertical: 12),
    this.gradientColors = const [],
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
          ChangeNotifierProvider<_GradientColourViewModel>.value(
            value: _GradientColourViewModel(gradientColors, reselectable, value),
            child: Consumer<_GradientColourViewModel>(
              builder: (context, controller, _) => Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  ...gradientColors.map(
                    (gradient) => _GradientItem(
                      isSelected: controller.isGradientColorSelected(gradient),
                      gradient: gradient,
                      onTap: (gradientColor) {
                        controller.select = gradientColor;
                        onPick?.call(gradientColor);
                      },
                    ),
                  ),
                  _GradientItem(
                    isSelected: controller.isColorPicked,
                    gradient: LinearGradient(colors: [controller.pickerColor, controller.pickerColor]),
                    child: const Icon(
                      Iconsax.brush_4,
                      size: 16,
                      color: Colors.black,
                    ),
                    onTap: (_) => style.showColorPicker(
                      controller.pickerColor,
                      onColorChanged: (Color color) {
                        controller.pick = LinearGradient(colors: [color, color]);
                        onPick?.call(LinearGradient(colors: [color, color]));
                      },
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

class _GradientItem extends StatelessWidget {
  final Gradient gradient;
  final bool isSelected;
  final Widget? child;
  final Function(Gradient)? onTap;
  const _GradientItem({
    required this.gradient,
    this.isSelected = false,
    this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return InkWell(
      radius: 36,
      onTap: () => onTap?.call(gradient),
      child: Clipper.circle(
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
        child: Clipper.circle(gradient: gradient, child: child,),
      ),
    );
  }
}

class _GradientColourViewModel extends ChangeNotifier {
  late final bool _reselectable;
  late bool _chooseFromPicker;
  late Gradient? _selectedColor;
  late Color _pickerColor;

  _GradientColourViewModel(List<Gradient> gradientColors, this._reselectable,
      [Gradient? gradient])
      : _chooseFromPicker =
            !(gradient == null || gradientColors.contains(gradient)),
        _selectedColor = gradient,
        _pickerColor = gradient == null || gradientColors.contains(gradient)
            ? Colors.white
            : gradient.colors.first;

  bool get chooseFromPicker => _chooseFromPicker;

  Gradient? get selectedColor => _selectedColor;

  Color get pickerColor => _pickerColor;

  bool isGradientColorSelected(Gradient color) =>
      !_chooseFromPicker && (_selectedColor == color);

  bool get isColorPicked =>
      _chooseFromPicker && (_selectedColor == LinearGradient(colors: [_pickerColor, _pickerColor]));

  set select(Gradient color) {
    _chooseFromPicker = false;
    if (_reselectable) {
      _selectedColor = _selectedColor == color ? null : color;
    } else if (_selectedColor == color) {
    } else {
      _selectedColor = color;
    }
    notifyListeners();
  }

  set pick(Gradient gradient) => this
    .._chooseFromPicker = true
    .._pickerColor = gradient.colors.first
    .._selectedColor = gradient
    ..notifyListeners();
}
