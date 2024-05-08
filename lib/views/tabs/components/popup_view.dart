import 'package:flutter/material.dart';
import '../../../widgets/clipper_widget.dart';

class ModalBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final EdgeInsets padding;
  final List<Widget> children;

  const ModalBottomSheet({
    super.key,
    required this.scrollController,
    this.padding = const EdgeInsets.only(top: 24),
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.scaffoldBackgroundColor.withOpacity(.75),
            theme.scaffoldBackgroundColor.withOpacity(.85),
            theme.scaffoldBackgroundColor.withOpacity(1),
          ],
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(.1),
            blurRadius: 16,
            offset: const Offset(0, -8),
          )
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          ListView(
            shrinkWrap: false,
            padding: padding,
            controller: scrollController,
            children: children,
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
