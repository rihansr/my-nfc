import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_nfc/services/navigation_service.dart';
import 'package:provider/provider.dart';
import '../../utils/debug.dart';
import '../../viewmodels/design_viewmodel.dart';
import '../settings/section_settings.dart';
import 'components/popup_view.dart';

// ignore: must_be_immutable
class DesignView extends StatelessWidget {
  late DesignViewModel viewModel;
  final ScrollController scrollController;

  DesignView({
    super.key,
    required this.scrollController,
  }) : viewModel =
            Provider.of<DesignViewModel>(navigator.context, listen: false);

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      scrollController: scrollController,
      children: viewModel.designStructure.entries
          .map(
            (e) => SectionSettings(
              key: Key(e.key),
              defaultBlock: viewModel.defaultStructure[e.key],
              block: e.value,
              onUpdate: (section) {
                viewModel
                  ..designStructure[e.key] = section
                  ..notify;
                debug.print(json.encode(viewModel.designStructure));
              },
            ),
          )
          .toList(),
    );
  }
}
