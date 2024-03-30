import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/debug.dart';
import '../../viewmodels/design_viewmodel.dart';
import '../blocks/section_settings.dart';
import 'components/popup_view.dart';

class DesignView extends StatelessWidget {
  final ScrollController scrollController;
  const DesignView({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) => ModalBottomSheet(
        scrollController: scrollController,
        children: Provider.of<DesignViewModel>(context, listen: false)
            .designData
            .entries
            .map(
              (e) => SectionSettings(
                key: Key(e.key),
                block: e.value,
                onUpdate: (section) {
                  Provider.of<DesignViewModel>(context, listen: false)
                      ..designData[e.key] = section..notify;
                  debug.print(json.encode(
                      Provider.of<DesignViewModel>(context, listen: false)
                          .designData));
                },
              ),
            )
            .toList(),
      );
}
