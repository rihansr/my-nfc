import 'package:flutter/material.dart';

class Seekbar extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final TextAlign titleAlign;
  final EdgeInsets titleSpacing;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final num min;
  final num value;
  final num max;
  final Function(int)? onUpdate;

  const Seekbar({
    super.key,
    this.title,
    this.titleStyle,
    this.titleAlign = TextAlign.start,
    this.titleSpacing = const EdgeInsets.only(bottom: 10),
    this.margin = const EdgeInsets.symmetric(vertical: 10),
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.min = 0,
    int value = 0,
    this.max = 100,
    this.onUpdate,
  }) : value = value < min
            ? min
            : value > max
                ? max
                : value;

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
          Padding(
            padding: padding,
            child: Slider(
              value: value.toDouble(),
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: max.toInt() - min.toInt(),
              onChanged: (value) => onUpdate?.call(value.toInt()),
            ),
          )
        ],
      ),
    );
  }
}
