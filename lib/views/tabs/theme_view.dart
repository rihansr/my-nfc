import 'package:flutter/material.dart';
import 'components/popup_view.dart';

class ThemeView extends StatelessWidget {
  final ScrollController scrollController;
  const ThemeView({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) => ModalBottomSheet(
        scrollController: scrollController,
        children: const [],
      );
}
