import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../shared/dimens.dart';
import '../shared/strings.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../widgets/base_widget.dart';
import '../widgets/button_widget.dart';
import 'preview.dart';
import 'tabs/design_view.dart';
import 'tabs/theme_view.dart';

class LandingView extends StatelessWidget {
  final String? uid;
  final bool isPreview;
  const LandingView({this.uid, this.isPreview = true, super.key});

  @override
  Widget build(BuildContext context) => BaseWidget<DashboardViewModel>(
        model: Provider.of<DashboardViewModel>(context),
        onInit: (controller) => controller.init(context, uid, isPreview),
        builder: (context, controller, _) {
          ThemeData theme = Theme.of(context);
          bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
          return Scaffold(
            key: controller.scaffoldKey,
            backgroundColor: Colors.transparent,
            drawerScrimColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(color: theme.iconTheme.color),
              actions: controller.isPreview
                  ? []
                  : [
                      Button(
                        label: string.save,
                        fillColor: theme.colorScheme.surface,
                        margin: EdgeInsets.only(
                          right: controller.theme.horizontalPadding,
                        ),
                        onPressed: controller.save,
                      ),
                    ],
            ),
            drawer: isMobile || controller.isPreview
                ? null
                : Drawer(
                    backgroundColor: theme.colorScheme.surface,
                    width: (() {
                      final responsive = ResponsiveBreakpoints.of(context);
                      if (responsive.isMobile) {
                        return double.infinity;
                      } else if (responsive.isTablet) {
                        return responsive.screenWidth / 2;
                      } else if (responsive.isDesktop) {
                        return responsive.screenWidth / 4;
                      } else {
                        return responsive.screenWidth / 5;
                      }
                    }()),
                    child: SafeArea(
                      child: DefaultTabController(
                        length: 2,
                        initialIndex: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: TabBarView(children: [
                                DesignView(),
                                ThemeView(controller)
                              ]),
                            ),
                            TabBar(
                              tabs: [
                                Tab(text: string.design),
                                Tab(text: string.theme)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
            body: Preview(controller: controller),
            bottomNavigationBar: !controller.isPreview && isMobile
                ? Container(
                    color: theme.colorScheme.surface,
                    constraints: BoxConstraints(maxWidth: dimen.maxMobileWidth),
                    child: SafeArea(
                      top: false,
                      child: DefaultTabController(
                        length: 2,
                        initialIndex: 0,
                        child: TabBar(
                          tabs: [
                            Tab(text: string.design),
                            Tab(text: string.theme)
                          ],
                          onTap: controller.showsModalBottomSheet,
                        ),
                      ),
                    ),
                  )
                : null,
          );
        },
      );
}
