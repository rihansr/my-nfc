import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/debouncer.dart';
import '../shared/dimens.dart';
import '../utils/extensions.dart';
import '../models/theme_model.dart';
import '../views/tabs/design_view.dart';
import '../views/tabs/theme_view.dart';
import '../shared/constants.dart';
import 'base_viewmodel.dart';

class DashboardViewModel extends BaseViewModel {
  final bool isPreview;
  late String? _uid;
  final GlobalKey<ScaffoldState> scaffoldKey;
  late ThemeModel _theme;
  final Map<String, dynamic> defaultStructure;
  late Map<String, dynamic> designStructure;
  late Debouncer _scrollingDebounce;

  // Keys
  Map<String, GlobalKey> keys = {};
  bool isSelected(GlobalKey? key) =>
      selectedKey == null || key == null ? false : key == selectedKey;
  GlobalKey? selectedKey;
  GlobalKey? key(String path) => keys[path];
  set keyPath(String path) {
    if (keys.containsKey(path)) return;
    keys[path] = GlobalKey(debugLabel: path);
  }

  scroll(Key? key) {
    String? path = key != null
        ? RegExp(r"\[<\'(.*)\'\>\]").firstMatch(key.toString())?.group(1)
        : null;
    if (path != null) keyPath = path;
    GlobalKey? globalKey = path != null ? keys[path] : null;
    selectedKey = globalKey;
    notifyListeners();
    _scrollingDebounce.run(() {
      if (globalKey?.currentContext == null) return;
      Scrollable.ensureVisible(
        globalKey!.currentContext!,
        alignment: 0.5,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 500),
      );
    });
  }

  List<Map<String, dynamic>> get footers =>
      designStructure.filterBy(const MapEntry('subBlock', 'actions_footer'));

  DashboardViewModel(this._uid, {bool isPeview = false})
      : isPreview = isPeview,
        scaffoldKey = GlobalKey<ScaffoldState>(),
        defaultStructure = jsonDecode(kDefaultBlocks);

  init(String? uid) {
    _uid = uid;
    _theme = (() {
      String? theme = localDb.get('${_uid ?? ''}_theme');
      return theme != null
          ? ThemeModel.fromMap(jsonDecode(theme))
          : kThemes.first;
    }());
    designStructure = jsonDecode(
        localDb.get('${_uid ?? ''}_design', defaultValue: kDefaultBlocks)!);
    _scrollingDebounce =
        Debouncer(duraction: const Duration(milliseconds: 100));
    localDb.put('theme', jsonEncode(theme.toMap()));
  }

  ThemeModel get theme => _theme;
  set theme(ThemeModel theme) {
    this
      .._theme = theme
      ..notifyListeners();
    localDb.put('${_uid ?? ''}_theme', jsonEncode(theme.toMap()));
  }

  save() {
    localDb.put('${_uid ?? ''}_design', jsonEncode(defaultStructure));
  }

  showsModalBottomSheet(int tab) => scaffoldKey.currentState?.showBottomSheet(
        constraints: BoxConstraints(maxWidth: dimen.maxMobileWidth),
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
      )?..closed.then((_) => scroll(null));

  @override
  void dispose() {
    _scrollingDebounce.dispose();
    super.dispose();
  }
}
