import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_nfc/utils/debug.dart';
import '../shared/dimens.dart';
import '../utils/extensions.dart';
import '../models/theme_model.dart';
import '../views/tabs/design_view.dart';
import '../views/tabs/theme_view.dart';
import '../shared/constants.dart';
import 'base_viewmodel.dart';

class DesignViewModel extends BaseViewModel {
  final BuildContext _context;
  final ScrollController scrollController = ScrollController();
  final Map<String, String>? _params;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Map<String, dynamic> defaultStructure;
  final Map<String, dynamic> designStructure;
  GlobalKey? selectedKey;

  scroll(Key? key) {
    selectedKey = key as GlobalKey?;
    notifyListeners();
    debug.print('scrolling to $key');
    if (key is! GlobalKey) return;
    /* final RenderObject? renderObject = key.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      scrollController.animateTo(
        renderObject.localToGlobal(Offset.zero).dy,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } */
  }

  List<Map<String, dynamic>> get footers =>
      designStructure.filterBy(const MapEntry('subBlock', 'actions_footer'));

  DesignViewModel(this._context, [this._params])
      : scaffoldKey = GlobalKey<ScaffoldState>(),
        defaultStructure = jsonDecode(kDefaultBlocks),
        designStructure = jsonDecode(kDefaultBlocks);

  init(Map<String, String>? params) {
    if (params != null) _params?.addAll(params);
  }

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
      constraints: BoxConstraints(maxWidth: dimen.maxMobileWidth));
}
