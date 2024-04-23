import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/debug.dart';
import '../../viewmodels/design_viewmodel.dart';
import '../settings/section_settings.dart';
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
            .designStructure
            .entries
            .map(
              (e) => SectionSettings(
                key: Key(e.key),
                block: e.value,
                onUpdate: (section) {
                  Provider.of<DesignViewModel>(context, listen: false)
                    ..designStructure[e.key] = section
                    ..notify;
                  debug.print(json.encode(
                      Provider.of<DesignViewModel>(context, listen: false)
                          .designStructure));
                },
              ),
            )
            .toList(),
      );
}
