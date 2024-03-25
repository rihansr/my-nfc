import 'dart:convert';
import 'package:flutter/material.dart';
import '../../utils/debug.dart';
import '../../viewmodels/design_viewmodel.dart';
import '../blocks/section_settings.dart';
import 'components/popup_view.dart';

class DesignView extends StatelessWidget {
  final ScrollController scrollController;
  final DesignViewModel controller;
  final Map<String, dynamic> _data;
   DesignView({
    super.key,
    required this.scrollController,
    required this.controller,
  }) : _data = {}..addAll(controller.designData);

  @override
  Widget build(BuildContext context) => PopupView(
        scrollController: scrollController,
        children: _data.entries
            .map(
              (e) => SectionSettings(
                key: Key(e.key),
                settings: e.value,
                onUpdate: (section) {
                  controller.designData[e.key] = section;
                  debug.print(json.encode(controller.designData));
                },
              ),
            )
            .toList(),
      );
}
