import 'package:flutter/material.dart';

class Dropdown<T> extends StatelessWidget {
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
  final Function(T?)? onSelected;

  Dropdown({
    super.key,
    this.fillColor,
    this.onSelected,
    this.width,
    this.height,
    this.hint,
    this.maxLines,
    this.borderSize = 0.75,
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
  }) : _selectedItem = ValueNotifier(value);

  final ValueNotifier<T?> _selectedItem;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      width: width,
      margin: margin,
      child: Column(
        crossAxisAlignment:
            isExpanded ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
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
          Container(
            padding: padding,
            decoration: borderFocusable
                ? BoxDecoration(
                    borderRadius: bottomBorderOnly
                        ? null
                        : BorderRadius.all(Radius.circular(borderRadius)),
                    border: bottomBorderOnly
                        ? Border(
                            bottom: BorderSide(
                              color: borderTint ?? theme.hintColor,
                              width: borderSize,
                            ),
                          )
                        : Border.all(
                            color: borderTint ?? theme.hintColor,
                            width: borderSize,
                          ),
                  )
                : null,
            child: ValueListenableBuilder(
                valueListenable: _selectedItem,
                builder: (_, selectedItem, __) {
                  return DropdownButton<T?>(
                    menuMaxHeight: height,
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadius)),
                    isDense: dense,
                    isExpanded: isExpanded,
                    dropdownColor: fillColor,
                    hint: hintWidget ??
                        Text(
                          hint ?? '',
                          maxLines: maxLines,
                          style: hintStyle ??
                              theme.textTheme.bodySmall?.copyWith(
                                color: hintColor ?? theme.hintColor,
                                fontSize: fontSize,
                                fontWeight: fontWeight,
                              ),
                        ),
                    value: selectedItem,
                    style: (textStyle ?? theme.textTheme.bodySmall)?.copyWith(
                      color: fontColor,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      overflow: TextOverflow.ellipsis,
                    ),
                    underline: const SizedBox.shrink(),
                    items: itemBuilder == null
                        ? null
                        : items.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: itemBuilder!(item),
                            );
                          }).toList(),
                    selectedItemBuilder: selectedItemBuilder == null
                        ? null
                        : (_) => items.map<Widget>((item) {
                              return Align(
                                  alignment: Alignment.centerLeft,
                                  child: selectedItemBuilder!(item));
                            }).toList(),
                    onChanged: (T? item) {
                      if (_selectedItem.value == item) {
                        return;
                      } else if (maintainState) {
                        _selectedItem.value = item;
                      }
                      onSelected?.call(item);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
