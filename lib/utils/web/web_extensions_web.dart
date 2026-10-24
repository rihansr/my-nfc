import 'dart:js_interop';
import 'package:web/web.dart' as web;

final webExtension = WebExtension.function;

class WebExtension {
  static WebExtension get function => WebExtension._();

  WebExtension._();

  Future<void> saveVCard(String? label, String vCard) async {
    final fileName = label?.trim().isNotEmpty == true
        ? label!.trim()
        : DateTime.now().toIso8601String();

    final blob = web.Blob(
      [vCard.toJS].toJS,
      web.BlobPropertyBag(type: 'text/vcard'),
    );

    final url = web.URL.createObjectURL(blob);
    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..download = '$fileName.vcf'
      ..target = '_blank';

    web.document.body?.append(anchor);
    anchor.click();
    anchor.remove();

    web.URL.revokeObjectURL(url);
  }
}