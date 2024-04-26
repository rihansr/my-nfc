import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/dimens.dart';
import '../viewmodels/design_viewmodel.dart';
import 'blocks/actions_block.dart';
import 'blocks/section_block.dart';

class Preview extends StatelessWidget {
  final Map<String, String>? params;
  final DesignViewModel? designController;
  const Preview({super.key, this.params, this.designController});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          ChangeNotifierProvider<DesignViewModel>.value(
        value: designController ?? DesignViewModel(context, params),
        child: Consumer<DesignViewModel>(
          builder: (context, controller, _) => Scaffold(
            extendBody: true,
            body: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: dimen.maxMobileWidth,
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
                      const SafeArea(top: false, child: SizedBox.shrink())
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Center(
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: dimen.maxMobileWidth),
                child: Column(
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
                          child: SafeArea(top: false, child: ActionsBlock(e)),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
