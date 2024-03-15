import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../widgets/glassmorphism.dart';
import '../../widgets/clipper_widget.dart';
import '../blocks/section_block.dart';

class DesignView extends StatelessWidget {
  final ScrollController scrollController;
  final Map<String, dynamic> design;
  const DesignView({
    super.key,
    required this.scrollController,
    required this.design,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Glassmorphism(
      color: theme.colorScheme.tertiary,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          ListView(
            shrinkWrap: false,
            padding: const EdgeInsets.only(top: 24),
            controller: scrollController,
            children: design.values
                .map(
                  (e) => SectionBlock(data: e),
                )
                .toList(),
          ),
          Container(
            padding: const EdgeInsets.only(top: 16),
            width: double.infinity,
            height: 32,
            alignment: Alignment.topCenter,
            child: IgnorePointer(
              ignoring: true,
              child: Clipper(
                shape: const StadiumBorder(),
                height: 4,
                width: 48,
                color: theme.disabledColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
