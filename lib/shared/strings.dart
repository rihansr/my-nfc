import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/navigation_service.dart';

AppLocalizations get string => AppLocalizations.of(navigator.context)!;

class Strings {
  static AppLocalizations of(BuildContext context) =>
      AppLocalizations.of(context)!;
}
