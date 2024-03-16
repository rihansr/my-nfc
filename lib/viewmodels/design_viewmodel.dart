import 'package:flutter/material.dart';
import '../views/tabs/design_view.dart';
import '../views/tabs/theme_view.dart';
import '../shared/constants.dart';
import 'base_viewmodel.dart';

class DesignViewModel extends BaseViewModel {
  final BuildContext _context;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Map<String, dynamic> _params;
  final Map<String, dynamic> _designData;

  DesignViewModel(BuildContext context, {required Map<String, dynamic> params})
      : _context = context,
        _params = params,
        scaffoldKey = GlobalKey<ScaffoldState>(),
        _designData = kDefaultDesign;

  Map<String, dynamic> get designData => _designData;

  showsModalBottomSheet(int tab) => scaffoldKey.currentState?.showBottomSheet(
        (context) => DraggableScrollableSheet(
          initialChildSize: .46,
          minChildSize: 0,
          maxChildSize: .7,
          expand: true,
          builder: (context, scrollController) {
            switch (tab) {
              case 0:
                return DesignView(
                  scrollController: scrollController,
                  controller: this,
                );
              case 1:
                return ThemeView(
                  scrollController: scrollController,
                  controller: this,
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      );
}
