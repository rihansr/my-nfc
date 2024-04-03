import 'package:flutter/material.dart';
import '../shared/strings.dart';
import '../widgets/button_widget.dart';

class Seekbar extends StatelessWidget {
  final String? title;
  final String? type;
  final TextStyle? titleStyle;
  final TextAlign titleAlign;
  final EdgeInsets titleSpacing;
  final EdgeInsets margin;
  final num min;
  final num? defaultValue;
  final num value;
  final num max;
  final bool showCount;
  final bool maintainState;
  final Function(int)? onChanged;

  Seekbar({
    super.key,
    this.title,
    this.type,
    this.titleStyle,
    this.titleAlign = TextAlign.start,
    this.titleSpacing = const EdgeInsets.only(bottom: 10),
    margin,
    padding,
    this.min = 0,
    this.value = 0,
    int? defaultValue,
    this.max = 100,
    this.showCount = true,
    this.maintainState = true,
    this.onChanged,
  })  : _selectedValue = ValueNotifier((value < min
                ? min
                : value > max
                    ? max
                    : value)
            .toDouble()),
        margin = margin ??
            (defaultValue == null || !showCount
                ? const EdgeInsets.symmetric(vertical: 12)
                : const EdgeInsets.symmetric(vertical: 8)),
        defaultValue = defaultValue == null
            ? null
            : defaultValue < min
                ? min
                : defaultValue > max
                    ? max
                    : defaultValue;

  final ValueNotifier<double> _selectedValue;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle? titleStyle = this.titleStyle ??
        theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        );

    return Container(
      width: double.infinity,
      margin: margin,
      child: ValueListenableBuilder(
          valueListenable: _selectedValue,
          builder: (context, value, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title?.trim().isNotEmpty ?? false)
                  Padding(
                    padding: titleSpacing,
                    child: Text.rich(
                      TextSpan(
                        text: title,
                        children: [
                          if (showCount) ...[
                            const TextSpan(text: ': '),
                            TextSpan(
                              text: (() {
                                switch (type?.toLowerCase()) {
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
                          ],
                          if (defaultValue != null)
                            WidgetSpan(
                              child: Button(
                                label: string.reset,
                                borderSize: 1,
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                                onPressed: () {
                                  if (maintainState) {
                                    _selectedValue.value =
                                        defaultValue?.toDouble() ?? 0.0;
                                  }
                                  onChanged?.call(defaultValue?.toInt() ?? 0);
                                },
                              ),
                              alignment: PlaceholderAlignment.middle,
                            ),
                        ],
                      ),
                      style: titleStyle,
                    ),
                  ),
                Transform.scale(
                  scale: 1.075,
                  child: Slider(
                    value: value,
                    min: min.toDouble(),
                    max: max.toDouble(),
                    divisions: max.toInt() - min.toInt(),
                    onChanged: (value) {
                      if (maintainState) _selectedValue.value = value;
                      onChanged?.call(value.toInt());
                    },
                  ),
                )
              ],
            );
          }),
    );
  }
}
