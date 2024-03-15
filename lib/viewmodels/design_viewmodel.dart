import 'package:flutter/material.dart';
import 'package:my_nfc/views/tabs/design_view.dart';
import 'package:my_nfc/views/tabs/theme_view.dart';
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
                  design: _designData,
                );
              case 1:
                return ThemeView(
                  scrollController: scrollController,
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      );
}
