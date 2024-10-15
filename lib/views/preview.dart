import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '../shared/dimens.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import 'blocks/actions_block.dart';
import 'blocks/section_block.dart';

class Preview extends StatelessWidget {
  final String? uid;
  final DashboardViewModel controller;
  const Preview({super.key, this.uid, required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          Scaffold(
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
                          .map((e) => SectionBlock(
                                e.value,
                                key: Key(e.key),
                                parent: controller,
                                path: e.key,
                              )),
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
                      .mapIndexed(
                        (i, e) => Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: controller.theme.horizontalPadding),
                          child: SafeArea(
                            top: false,
                            child:
                                ActionsBlock(e, path: '$i', parent: controller),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
    );
  }
}
