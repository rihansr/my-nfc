import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/strings.dart';
import '../viewmodels/design_viewmodel.dart';
import '../widgets/base_widget.dart';

class LandingView extends StatelessWidget {
  final Map<String, String>? params;
  const LandingView({this.params, super.key});

  @override
  Widget build(BuildContext context) => Builder(builder: (context) {
        ThemeData theme = Theme.of(context);
        return BaseWidget<DesignViewModel>(
          model: Provider.of<DesignViewModel>(context),
          onInit: (controller) {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => controller.showsModalBottomSheet(0));
          },
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
        );
      });
}
