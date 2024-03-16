import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/design_viewmodel.dart';
import '../blocks/section_block.dart';
import 'components/popup_view.dart';

class DesignView extends StatelessWidget {
  final ScrollController scrollController;
  final DesignViewModel controller;
  const DesignView({
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
            children: controller.designData.entries
                .map(
                  (e) => SectionBlock(
                    key: Key(e.key),
                    data: MapEntry(e.key, e.value),
                  ),
                )
                .toList(),
          ),
        ),
      );
}
