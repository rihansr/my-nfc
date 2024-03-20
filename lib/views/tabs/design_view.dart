import 'package:flutter/material.dart';
import 'package:my_nfc/utils/debug.dart';
import '../../shared/constants.dart';
import '../../viewmodels/design_viewmodel.dart';
import '../blocks/section_block.dart';
import 'components/popup_view.dart';

class DesignView extends StatefulWidget {
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
  State<DesignView> createState() => _DesignViewState();
}

class _DesignViewState extends State<DesignView> {
  @override
  void initState() {
    debug.print(kExpansionStates);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => PopupView(
        scrollController: widget.scrollController,
        children: widget.data.entries
            .map(
              (e) => SectionBlock(
                key: Key(e.key),
                data: e.value,
                onUpdate: (section) => widget.controller.notify,
              ),
            )
            .toList(),
      );
}
