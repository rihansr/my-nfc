import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/strings.dart';
import '../viewmodels/design_viewmodel.dart';
import '../widgets/base_widget.dart';
import 'blocks/actions_block.dart';
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
          builder: (context, controller, child) => Scaffold(
            key: controller.scaffoldKey,
            backgroundColor: Colors.transparent,
            body: Scaffold(
              extendBody: true,
              body: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: controller.theme.horizontalPadding),
                    decoration:
                        BoxDecoration(gradient: controller.theme.background),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...controller.designStructure.entries
                            .map((e) => SectionBlock(e.value, key: Key(e.key))),
                        const SafeArea(child: SizedBox.shrink())
                      ],
                    ),
                  ),
                );
              }),
              bottomNavigationBar: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: controller.footers
                    .where((element) =>
                        (element['settings']?['advanced']
                                ?['buttonFixedAtBottom'] ??
                            false) &&
                        (element['settings']?['visible'] ?? true))
                    .map(
                      (e) => Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: controller.theme.horizontalPadding),
                        child: ActionsBlock(e),
                      ),
                    )
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
        );
      });
}
