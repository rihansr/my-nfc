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
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          ListView(
            shrinkWrap: false,
            controller: scrollController,
            children: const [],
          ),
          Positioned(
            top: 16,
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
