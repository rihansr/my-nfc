import 'package:flutter/material.dart';
import '../../viewmodels/design_viewmodel.dart';
import '../blocks/section_block.dart';
import 'components/popup_view.dart';

class DesignView extends StatelessWidget {
  final ScrollController scrollController;
  final DesignViewModel controller;
  final Map<String, dynamic> data;
  const DesignView({
    super.key,
    required this.scrollController,
    required this.controller,
    required this.data,
  });

  @override
  Widget build(BuildContext context) => PopupView(
        scrollController: scrollController,
        children: data.entries
            .map(
              (e) => SectionBlock(
                key: Key(e.key),
                data: e.value,
                onUpdate: (section) => controller.notify,
              ),
            )
            .toList(),
      );
}
