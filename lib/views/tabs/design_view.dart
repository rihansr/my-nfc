import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_nfc/services/navigation_service.dart';
import 'package:provider/provider.dart';
import '../../utils/debug.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../settings/section_settings.dart';
import 'components/popup_view.dart';

// ignore: must_be_immutable
class DesignView extends StatelessWidget {
  late DashboardViewModel viewModel;
  final ScrollController? scrollController;

  DesignView({
    super.key,
    this.scrollController,
  }) : viewModel =
            Provider.of<DashboardViewModel>(navigator.context, listen: false);

  @override
  Widget build(BuildContext context) {
    return (() {
      final children = viewModel.designStructure.entries
          .map(
            (e) => SectionSettings(
              key: Key(e.key),
              path: e.key,
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
          .toList();
      return scrollController != null
          ? ModalBottomSheet(
              scrollController: scrollController!,
              children: children,
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 32, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            );
    }());
  }
}
