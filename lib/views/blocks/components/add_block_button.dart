

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '../../../shared/constants.dart';
import '../../../shared/strings.dart';

class AddBlockButton extends StatelessWidget {
  final Function(Map<String, dynamic>)? onSelected;
  const AddBlockButton({super.key, this.onSelected});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 28),
      child: PopupMenuButton<Map<String, dynamic>>(
        itemBuilder: (context) {
          return kAdditionalBlocks
              .mapIndexed(
                (i, e) => PopupMenuItem<Map<String, dynamic>>(
                  value: e,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text.rich(
                    TextSpan(
                      style: theme.textTheme.bodySmall,
                      children: [
                        WidgetSpan(
                          child: Icon(
                            '${e['block']}'.icon,
                            size: 16,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                          alignment: PlaceholderAlignment.middle,
                        ),
                        const TextSpan(text: "  "),
                        TextSpan(text: e['label'] ?? ""),
                      ],
                    ),
                  ),
                ),
              )
              .toList();
        },
        offset: const Offset(-3, 0),
        color: theme.scaffoldBackgroundColor,
        elevation: 2,
        onSelected: onSelected,
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