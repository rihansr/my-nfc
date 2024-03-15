import 'package:flutter/material.dart';
import '../../widgets/clipper_widget.dart';
import '../../widgets/glassmorphism.dart';

class ThemeView extends StatelessWidget {
  final ScrollController scrollController;
  const ThemeView({super.key, required this.scrollController});

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
            children: const [],
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
