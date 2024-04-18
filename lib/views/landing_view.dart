import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/strings.dart';
import '../viewmodels/design_viewmodel.dart';
import '../widgets/base_widget.dart';
import 'blocks/section_block.dart';

class LandingView extends StatelessWidget {
  final Map<String, String>? params;
  const LandingView({this.params, super.key});

  @override
  Widget build(BuildContext context) => Builder(builder: (context) {
        return BaseWidget<DesignViewModel>(
          model: Provider.of<DesignViewModel>(context),
          onInit: (controller) {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => controller.showsModalBottomSheet(0));
            
          },
          builder: (context, controller, child) => DecoratedBox(
            decoration: BoxDecoration(gradient: controller.theme.background),
            child: Scaffold(
              key: controller.scaffoldKey,
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: controller.theme.horizontalPadding),
                primary: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: controller.designData.entries
                      .map((e) => SectionBlock(e.value, key: Key(e.key)))
                      .toList(),
                ),
              ),
              bottomNavigationBar: Container(
                color: Theme.of(context).colorScheme.background,
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
