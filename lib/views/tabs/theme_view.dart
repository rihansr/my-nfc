import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/design_viewmodel.dart';
import 'components/popup_view.dart';

class ThemeView extends StatelessWidget {
  final ScrollController scrollController;
  final DesignViewModel controller;
  const ThemeView({
    super.key,
    required this.scrollController,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) =>
   ChangeNotifierProvider<DesignViewModel>.value(
      value: controller,
      child: Consumer<DesignViewModel>(
        builder: (context, controller, _) => PopupView(
          scrollController: scrollController,
          children: const [],
        ),
      ),
    );
}
