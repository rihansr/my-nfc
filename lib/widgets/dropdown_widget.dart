import 'package:flutter/material.dart';

class Dropdown<T> extends StatefulWidget {
  final Color? fillColor;
  final double? width;
  final double? height;
  final Color? fontColor;
  final Color? hintColor;
  final FontWeight? fontWeight;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final String? hint;
  final Widget? hintWidget;
  final int? maxLines;
  final double borderSize;
  final Color? borderTint;
  final String? title;
  final TextStyle? titleStyle;
  final TextAlign titleAlign;
  final EdgeInsets titleSpacing;
  final Widget? icon;
  final Color? iconColor;
  final bool dense;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double? fontSize;
  final double borderRadius;
  final bool bottomBorderOnly;
  final List<T> items;
  final Widget Function(T)? itemBuilder;
  final Widget Function(T)? selectedItemBuilder;
  final T? value;
  final bool isExpanded;
  final bool maintainState;
  final bool borderFocusable;
  final Function(T)? onSelected;

  const Dropdown({
    super.key,
    this.fillColor,
    this.onSelected,
    this.width,
    this.height,
    this.hint,
    this.maxLines,
    this.borderSize = 1,
    this.borderTint,
    this.title,
    this.titleAlign = TextAlign.start,
    this.titleStyle,
    this.titleSpacing = const EdgeInsets.only(bottom: 10),
    this.value,
    this.items = const [],
    this.itemBuilder,
    this.selectedItemBuilder,
    this.margin = const EdgeInsets.symmetric(vertical: 12),
    this.padding = const EdgeInsets.all(8),
    this.fontSize,
    this.dense = true,
    this.hintWidget,
    this.fontColor,
    this.hintColor,
    this.fontWeight,
    this.textStyle,
    this.hintStyle,
    this.iconColor,
    this.icon,
    this.isExpanded = true,
    this.maintainState = true,
    this.borderRadius = 3,
    this.borderFocusable = true,
    this.bottomBorderOnly = false,
  });

  @override
  State<Dropdown<T>> createState() => _DropdownState<T>();
}

class _DropdownState<T> extends State<Dropdown<T>> {
  T? selectedItem;
  @override
  void initState() {
    selectedItem = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      width: widget.width,
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: widget.isExpanded
            ? CrossAxisAlignment.stretch
            : CrossAxisAlignment.start,
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
          Container(
            padding: widget.padding,
            decoration: widget.borderFocusable
                ? BoxDecoration(
                    borderRadius: widget.bottomBorderOnly
                        ? null
                        : BorderRadius.all(
                            Radius.circular(widget.borderRadius)),
                    border: widget.bottomBorderOnly
                        ? Border(
                            bottom: BorderSide(
                              color: widget.borderTint ?? theme.hintColor,
                              width: widget.borderSize,
                            ),
                          )
                        : Border.all(
                            color: widget.borderTint ?? theme.hintColor,
                            width: widget.borderSize,
                          ),
                  )
                : null,
            child: DropdownButton(
              menuMaxHeight: widget.height,
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.borderRadius)),
              isDense: widget.dense,
              isExpanded: widget.isExpanded,
              dropdownColor: widget.fillColor,
              hint: widget.hintWidget ??
                  Text(
                    widget.hint ?? '',
                    maxLines: widget.maxLines,
                    style: widget.hintStyle ??
                        theme.textTheme.bodySmall?.copyWith(
                          color: widget.hintColor ?? theme.hintColor,
                          fontSize: widget.fontSize,
                          fontWeight: widget.fontWeight,
                        ),
                  ),
              value: widget.maintainState ? selectedItem : widget.value,
              style: (widget.textStyle ?? theme.textTheme.bodySmall)?.copyWith(
                color: widget.fontColor,
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight,
                overflow: TextOverflow.ellipsis,
              ),
              underline: const SizedBox.shrink(),
              items: widget.itemBuilder == null
                  ? null
                  : widget.items.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: widget.itemBuilder!(item),
                      );
                    }).toList(),
              selectedItemBuilder: widget.selectedItemBuilder == null
                  ? null
                  : (_) => widget.items.map<Widget>((item) {
                        return Align(
                            alignment: Alignment.centerLeft,
                            child: widget.selectedItemBuilder!(item));
                      }).toList(),
              onChanged: (T? item) => {
                if (widget.maintainState) setState(() => selectedItem = item),
                if (item != null) widget.onSelected?.call(item),
              },
            ),
          ),
        ],
      ),
    );
  }
}
