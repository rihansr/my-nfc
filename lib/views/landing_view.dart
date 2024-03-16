import 'package:flutter/material.dart';
import '../shared/strings.dart';
import '../viewmodels/design_viewmodel.dart';
import '../widgets/base_widget.dart';

class LandingView extends StatelessWidget {
  final Map<String, String> params;
  const LandingView({required this.params, super.key});

  @override
  Widget build(BuildContext context) => Builder(builder: (context) {
        ThemeData theme = Theme.of(context);
        return BaseWidget<DesignViewModel>(
          model: DesignViewModel(context, params: params),
          onInit: (controller) =>
              WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
            controller.showsModalBottomSheet(0);
          }),
          builder: (context, controller, child) => BaseWidget<DesignViewModel>(
            model: DesignViewModel(context, params: params),
            builder: (context, controller, child) => Scaffold(
              key: controller.scaffoldKey,
              body: const Column(),
              bottomNavigationBar: Container(
                color: theme.colorScheme.background,
                child: SafeArea(
                  top: false,
                  child: DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: TabBar(
                      tabs: [Tab(text: string.design), Tab(text: string.theme)],
                      onTap: controller.showsModalBottomSheet,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      });
}
