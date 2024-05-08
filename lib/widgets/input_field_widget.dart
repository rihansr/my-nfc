import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../shared/styles.dart';

class InputField extends StatelessWidget {
  final TextEditingController? controller;
  final double? height;
  final double? width;
  final bool autoValidate;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isDense;
  final bool isCollapsed;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextStyle? textStyle;
  final String? hint;
  final String? title;
  final TextStyle? titleStyle;
  final TextAlign titleAlign;
  final EdgeInsets titleSpacing;
  final String? titleHint;
  final TextStyle? titleHintStyle;
  final bool obscureText;
  final TextAlign textAlign;
  final int? maxCharacters;
  final int maxLines;
  final int? minLines;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool typeable;
  final bool selectable;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final bool borderFocusable;
  final Color? fillColor;
  final Color? borderTint;
  final Color? fontColor;
  final Color? hintColor;
  final double? hintSize;
  final FontWeight? hintWeight;
  final TextStyle? hintStyle;
  final TextCapitalization textCapitalization;
  final int lengthFilter;
  final double borderRadius;
  final bool underlineOnly;
  final FocusNode? focusNode;
  final bool autoFocus;

  /// Action
  final String? Function(String?)? validator;
  final Function()? onTap;
  final TextInputAction? inputAction;
  final Function(String)? onAction;
  final Function(String)? onTyping;
  final Function(String?)? onQuery;

  const InputField({
    super.key,
    this.controller,
    this.height,
    this.width,
    this.validator,
    this.autoValidate = true,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.title,
    this.titleAlign = TextAlign.start,
    this.titleStyle,
    this.titleSpacing = const EdgeInsets.only(bottom: 10),
    this.titleHint,
    this.titleHintStyle,
    this.obscureText = false,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.minLines,
    this.suffixIcon,
    this.typeable = true,
    this.selectable = true,
    this.borderTint,
    this.maxCharacters,
    this.hint,
    this.hintSize,
    this.hintWeight,
    this.fontSize,
    this.fontWeight,
    this.textStyle,
    this.textCapitalization = TextCapitalization.none,
    this.isDense = false,
    this.isCollapsed = true,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    this.margin = const EdgeInsets.symmetric(vertical: 12),
    this.borderFocusable = true,
    this.onTap,
    this.prefix,
    this.prefixIcon,
    this.onAction,
    this.onTyping,
    this.lengthFilter = 1,
    this.borderRadius = 4,
    this.onQuery,
    this.fontColor,
    this.hintColor,
    this.hintStyle,
    this.fillColor,
    this.focusNode,
    this.autoFocus = false,
    this.inputAction,
    this.underlineOnly = false,
  });

  InputBorder boder(Color color) => style.inputBorder(
        borderFocusable ? borderTint ?? color : Colors.transparent,
        underlineOnly: underlineOnly,
        radius: borderRadius,
      );

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: height,
      width: width,
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title?.trim().isNotEmpty ?? false)
            Padding(
              padding: titleSpacing,
              child: Text.rich(
                TextSpan(
                  text: title,
                  style: titleStyle ??
                      theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  children: [
                    if (titleHint?.trim().isNotEmpty ?? false)
                      TextSpan(
                        text: '  $titleHint',
                        style: titleHintStyle ??
                            theme.textTheme.titleMedium?.copyWith(
                              color: hintColor ?? theme.hintColor,
                              fontSize: hintSize ?? fontSize,
                              fontWeight: hintWeight ?? fontWeight,
                            ),
                      ),
                  ],
                ),
                textAlign: titleAlign,
              ),
            ),
          TextFormField(
            controller: controller,
            readOnly: !typeable,
            autofocus: autoFocus,
            focusNode: focusNode,
            enableInteractiveSelection: selectable,
            textCapitalization: textCapitalization,
            onChanged: (value) {
              onTyping?.call(value.trim());
              int length = value.trim().length;
              if (length == 0 || length >= lengthFilter) {
                onQuery?.call(value.trim());
              }
            },
            textInputAction: inputAction,
            onFieldSubmitted: onAction,
            onTap: onTap,
            maxLength: maxCharacters,
            inputFormatters: inputFormatters ?? format(keyboardType),
            validator: validator,
            autovalidateMode: autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            keyboardType: keyboardType,
            textAlign: textAlign,
            obscureText: obscureText,
            maxLines: maxLines,
            minLines: minLines,
            style: (textStyle ?? theme.textTheme.bodySmall)?.copyWith(
              color: fontColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
            decoration: InputDecoration(
              filled: fillColor != null,
              fillColor: fillColor,
              hintText: hint,
              counterStyle: theme.textTheme.titleSmall,
              errorStyle: theme.textTheme.titleSmall
                  ?.copyWith(color: theme.colorScheme.error),
              hintStyle: hintStyle ??
                  (textStyle ?? theme.textTheme.bodySmall)?.copyWith(
                    color: hintColor ?? theme.hintColor,
                    fontSize: hintSize ?? fontSize,
                    fontWeight: hintWeight ?? fontWeight,
                  ),
              prefixIconConstraints: BoxConstraints(
                minWidth: theme.iconTheme.size! + padding.right,
                maxHeight: (textStyle ?? theme.textTheme.bodySmall)!.fontSize! +
                    padding.vertical,
              ),
              prefixIconColor: hintColor ?? theme.hintColor,
              prefix: prefix,
              prefixIcon: prefixIcon,
              suffixIconConstraints: BoxConstraints(
                minWidth: theme.iconTheme.size! + padding.left,
                maxHeight: (textStyle ?? theme.textTheme.bodySmall)!.fontSize! +
                    padding.vertical,
              ),
              suffixIconColor: hintColor ?? theme.hintColor,
              suffixIcon: suffixIcon,
              isDense: isDense,
              isCollapsed: isCollapsed,
              contentPadding: padding,
              disabledBorder: boder(theme.disabledColor),
              enabledBorder: boder(theme.hintColor),
              border: boder(theme.hintColor),
              focusedBorder: boder(theme.textTheme.bodySmall!.color!),
              errorBorder: boder(theme.colorScheme.error),
              focusedErrorBorder: boder(theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

List<TextInputFormatter> format(TextInputType? type,
    {bool allowDecimal = true}) {
  if (type == TextInputType.name) {
    return [FilteringTextInputFormatter.allow(RegExp(r'[ .a-zA-Z]*'))];
  } else if (type == TextInputType.phone) {
    return [FilteringTextInputFormatter.allow(RegExp(r'[+-\d]*'))];
  } else if (type == TextInputType.number) {
    return [
      FilteringTextInputFormatter.allow(
          allowDecimal ? RegExp(r'^\d+\.?\d*') : RegExp(r'\d*'))
    ];
  } else {
    return [];
  }
}
