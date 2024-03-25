import 'package:flutter/material.dart';

class CheckboxWidget extends StatefulWidget {
  final String? label;
  final bool? value;
  final double spacing;
  final bool _isExpanded;
  final Function(bool)? onChanged;

  const CheckboxWidget({
    super.key,
    this.label,
    this.value,
    this.spacing = 6,
    this.onChanged,
  }) : _isExpanded = false;

  const CheckboxWidget.expand({
    super.key,
    this.label,
    required this.value,
    this.spacing = 8,
    this.onChanged,
  }) : _isExpanded = true;

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  late bool _isChecked;

  set isChecked(bool checked) => setState(() => _isChecked = checked);

  @override
  void initState() {
    _isChecked = widget.value ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: 0.8,
          child: Checkbox(
            value: _isChecked,
            onChanged: (state) {
              isChecked = state!;
              widget.onChanged?.call(state);
            },
          ),
        ),
        if (widget.label != null) ...[
          SizedBox(width: widget.spacing),
          widget._isExpanded
              ? Expanded(
                  child: Text(
                    widget.label!,
                    style: theme.textTheme.titleMedium,
                  ),
                )
              : Text(
                  widget.label!,
                  style: theme.textTheme.titleMedium,
                ),
        ]
      ],
    );
  }
}
