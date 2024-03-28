import 'package:flutter/material.dart';

class PopupButton extends StatelessWidget {
  final String? label;
  final List items;
  final Function(Map<String, dynamic>)? onSelected;
  final IconData Function(Map<String, dynamic>)? icon;
  final String Function(Map<String, dynamic>)? name;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  const PopupButton({
    super.key,
    this.label,
    this.onSelected,
    required this.items,
    this.icon,
    this.name,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: margin,
      child: PopupMenuButton<Map<String, dynamic>>(
        itemBuilder: (context) {
          return items.map(
            (e) {
              Map<String, dynamic> item = Map.unmodifiable(e);
              return PopupMenuItem<Map<String, dynamic>>(
                value: item,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodySmall,
                    children: [
                      WidgetSpan(
                        child: Icon(
                          icon?.call(item),
                          size: 16,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                        alignment: PlaceholderAlignment.middle,
                      ),
                      const TextSpan(text: "  "),
                      TextSpan(text: name?.call(item)),
                    ],
                  ),
                ),
              );
            },
          ).toList();
        },
        offset: const Offset(-3, 0),
        color: theme.scaffoldBackgroundColor,
        elevation: 2,
        onSelected: (item) => onSelected?.call(Map.from(item)),
        child: Padding(
          padding: padding,
          child: Text.rich(
            TextSpan(
              style: theme.textTheme.bodySmall,
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.add,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  alignment: PlaceholderAlignment.middle,
                ),
                const TextSpan(text: "  "),
                TextSpan(text: label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
