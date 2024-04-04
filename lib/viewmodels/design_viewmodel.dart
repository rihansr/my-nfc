import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_nfc/models/theme_model.dart';
import '../views/tabs/design_view.dart';
import '../views/tabs/theme_view.dart';
import '../shared/constants.dart';
import 'base_viewmodel.dart';

class DesignViewModel extends BaseViewModel {
  final BuildContext _context;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Map<String, dynamic> designData;

  DesignViewModel(BuildContext context)
      : _context = context,
        scaffoldKey = GlobalKey<ScaffoldState>(),
        designData = jsonDecode(kDefaultBlocks);

  ThemeModel _theme = kThemes.first;
  ThemeModel get theme => _theme;
  set theme(ThemeModel theme) => this
    .._theme = theme
    ..notifyListeners();

  showsModalBottomSheet(int tab) => scaffoldKey.currentState?.showBottomSheet(
        (context) => DraggableScrollableSheet(
          initialChildSize: .46,
          minChildSize: 0,
          maxChildSize: .7,
          expand: true,
          builder: (_, scrollController) {
            switch (tab) {
              case 0:
                return DesignView(scrollController: scrollController);
              case 1:
                return ThemeView(this, scrollController: scrollController);
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      );
}
