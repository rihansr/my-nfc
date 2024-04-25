import 'package:flutter/material.dart';
import '../../../utils/extensions.dart';
import '../../../shared/strings.dart';
import '../../../widgets/seekbar_widget.dart';
import 'block_expansion_tile.dart';

class Spacing extends StatelessWidget {
  final String? title;
  final Map<String, dynamic>? defaultSpacing;
  final Map<String, dynamic>? spacing;
  final Function(MapEntry<String, Map<String, dynamic>>)? onUpdate;

  const Spacing({
    super.key,
    this.title,
    this.defaultSpacing,
    this.spacing,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return BlockExpansionTile(
      label: string.paddingAndMarginSettings,
      maintainState: false,
      initiallyExpanded: spacing?['initiallyExpanded'] == true,
      children: [
        if (spacing?.containsKey('padding') ?? false)
          ...Map<String, dynamic>.from(spacing?['padding'] ?? {}).entries.map(
                (entry) => Seekbar(
                  title: '${string.padding.capitalizeFirstOfEach} ${entry.key}',
                  type: 'px',
                  value: entry.value,
                  defaultValue: defaultSpacing?['padding']?[entry.key],
                  min: spacing?['limit']?['padding']?['min'] ?? 0,
                  max: spacing?['limit']?['padding']?['max'] ?? 100,
                  onChanged: (val) {
                    spacing?.addEntry('padding', MapEntry(entry.key, val));
                    onUpdate?.call(MapEntry("spacing", spacing!));
                  },
                ),
              ),
        if (spacing?.containsKey('margin') ?? false)
          ...Map<String, dynamic>.from(spacing?['margin'] ?? {}).entries.map(
                (entry) => Seekbar(
                  title: '${string.margin.capitalizeFirstOfEach} ${entry.key}',
                  type: 'px',
                  value: entry.value,
                  defaultValue: defaultSpacing?['margin']?[entry.key],
                  min: spacing?['limit']?['margin']?['min'] ?? 0,
                  max: spacing?['limit']?['margin']?['max'] ?? 100,
                  onChanged: (val) {
                    spacing?.addEntry('margin', MapEntry(entry.key, val));
                    onUpdate?.call(MapEntry("spacing", spacing!));
                  },
                ),
              ),
      ],
    );
  }
}
