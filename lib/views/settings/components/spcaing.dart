import 'package:flutter/material.dart';
import '../../../utils/extensions.dart';
import '../../../shared/strings.dart';
import '../../../widgets/seekbar_widget.dart';
import 'block_expansion_tile.dart';

// ignore: must_be_immutable
class Spacing extends StatelessWidget {
  final String? title;
  final Map<String, dynamic>? spacing;
  final Function(MapEntry<String, Map<String, dynamic>>)? onUpdate;

  const Spacing({
    super.key,
    this.title,
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
                  defaultValue: spacing?['default']?['padding'] ?? 0,
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
                  defaultValue: spacing?['default']?['margin'] ?? 0,
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
