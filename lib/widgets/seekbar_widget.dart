import 'package:flutter/material.dart';
import '../shared/strings.dart';
import '../widgets/button_widget.dart';

class Seekbar extends StatefulWidget {
  final String? title;
  final String? type;
  final TextStyle? titleStyle;
  final TextAlign titleAlign;
  final EdgeInsets titleSpacing;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final num min;
  final num? defaultValue;
  final num value;
  final num max;
  final bool showCount;
  final Function(int)? onChanged;

  const Seekbar({
    super.key,
    this.title,
    this.type,
    this.titleStyle,
    this.titleAlign = TextAlign.start,
    this.titleSpacing = const EdgeInsets.only(bottom: 10),
    margin,
    padding,
    this.min = 0,
    int value = 0,
    int? defaultValue,
    this.max = 100,
    this.showCount = true,
    this.onChanged,
  })  : value = value < min
            ? min
            : value > max
                ? max
                : value,
        margin = margin ??
            (defaultValue == null || !showCount
                ? const EdgeInsets.symmetric(vertical: 12)
                : const EdgeInsets.symmetric(vertical: 8)),
        padding = margin ??
            (defaultValue == null || !showCount
                ? const EdgeInsets.symmetric(vertical: 8)
                : const EdgeInsets.only(top: 6, bottom: 8)),
        defaultValue = defaultValue == null
            ? null
            : defaultValue < min
                ? min
                : defaultValue > max
                    ? max
                    : defaultValue;

  @override
  State<Seekbar> createState() => _SeekbarState();
}

class _SeekbarState extends State<Seekbar> {
  late double value;

  @override
  void initState() {
    value = widget.value.toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle? titleStyle = widget.titleStyle ??
        theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        );

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
              child: Text.rich(
                TextSpan(
                  text: widget.title,
                  children: widget.showCount
                      ? [
                          const TextSpan(text: ': '),
                          TextSpan(
                            text: (() {
                              switch (widget.type?.toLowerCase()) {
                                case 'pixel':
                                case 'px':
                                  return string.pxSize(value.toInt());
                                case 'percent':
                                case '%':
                                  return string.percent(value.toInt());
                                default:
                                  return string.size(value.toInt());
                              }
                            }()),
                          ),
                          if (widget.defaultValue != null)
                            WidgetSpan(
                              child: Button(
                                label: string.reset,
                                borderSize: 1,
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                                onPressed: () {
                                  setState(
                                    () =>
                                        value = widget.defaultValue!.toDouble(),
                                  );
                                  widget.onChanged?.call(value.toInt());
                                },
                              ),
                              alignment: PlaceholderAlignment.middle,
                            ),
                        ]
                      : [],
                ),
                style: titleStyle,
              ),
            ),
          Padding(
            padding: widget.padding,
            child: Slider(
              value: value,
              min: widget.min.toDouble(),
              max: widget.max.toDouble(),
              divisions: widget.max.toInt() - widget.min.toInt(),
              onChanged: (value) {
                setState(() => this.value = value);
                widget.onChanged?.call(value.toInt());
              },
            ),
          )
        ],
      ),
    );
  }
}
