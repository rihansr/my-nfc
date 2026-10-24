import 'package:flutter/foundation.dart';

final webExtension = WebExtension.function;

class WebExtension {
  static WebExtension get function => WebExtension._();

  WebExtension._();

  Future<void> saveVCard(String? label, String vCard) async {
    if (kIsWeb) {
      webExtension.saveVCard(label, vCard);
    } else {
      throw UnsupportedError(
        'Saving a vCard through the browser is only supported on web.',
      );
    }
  }
}
