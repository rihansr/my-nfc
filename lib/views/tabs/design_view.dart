import 'package:flutter/material.dart';
import '../../widgets/glassmorphism.dart';
import '../../widgets/clipper_widget.dart';

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
