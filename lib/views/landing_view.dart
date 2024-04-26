import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../shared/dimens.dart';
import '../shared/strings.dart';
import '../viewmodels/design_viewmodel.dart';
import '../widgets/base_widget.dart';
import 'preview.dart';
import 'tabs/design_view.dart';
import 'tabs/theme_view.dart';

class LandingView extends StatelessWidget {
  final Map<String, String>? params;
  const LandingView({this.params, super.key});

  @override
  Widget build(BuildContext context) => Builder(builder: (context) {
        return BaseWidget<DesignViewModel>(
          model: Provider.of<DesignViewModel>(context),
          onInit: (controller) {
            controller.init(params);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (ResponsiveBreakpoints.of(context).isMobile) {
                controller.showsModalBottomSheet(0);
              }
            });
          },
          builder: (context, controller, _) {
            ThemeData theme = Theme.of(context);
            bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
            return Scaffold(
              key: controller.scaffoldKey,
              backgroundColor: Colors.transparent,
              drawerScrimColor: Colors.transparent,
              extendBodyBehindAppBar: true,
              appBar: isMobile
                  ? null
                  : AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      iconTheme: IconThemeData(color: theme.iconTheme.color),
                    ),
              drawer: isMobile
                  ? null
                  : Drawer(
                      backgroundColor: theme.colorScheme.background,
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
              body: Preview(designController: controller),
              bottomNavigationBar: isMobile
                  ? Container(
                      color: theme.colorScheme.background,
                      constraints:
                          BoxConstraints(maxWidth: dimen.maxMobileWidth),
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
      });
}
