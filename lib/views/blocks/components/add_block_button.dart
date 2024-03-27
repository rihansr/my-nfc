import 'package:flutter/material.dart';
import '../../../shared/constants.dart';
import '../../../shared/strings.dart';

class AddBlockButton extends StatelessWidget {
  final List blocks;
  final Function(Map<String, dynamic>)? onSelected;
  const AddBlockButton({super.key, this.onSelected, required this.blocks});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 28),
      child: PopupMenuButton<Map<String, dynamic>>(
        itemBuilder: (context) {
          return blocks.map(
            (e) {
              Map<String, dynamic> block = Map.unmodifiable(e);
              return PopupMenuItem<Map<String, dynamic>>(
                value: block,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text.rich(
                  TextSpan(
                    style: theme.textTheme.bodySmall,
                    children: [
                      WidgetSpan(
                        child: Icon(
                          '${block['block']}'.icon,
                          size: 16,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                        alignment: PlaceholderAlignment.middle,
                      ),
                      const TextSpan(text: "  "),
                      TextSpan(text: block['label'] ?? ""),
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
        onSelected: (block) => onSelected?.call(Map.from(block)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                TextSpan(text: string.addANewBlock),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

