// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

final webExtension = WebExtension.function;

class WebExtension {
  static WebExtension get function => WebExtension._();
  WebExtension._();

  Future<void> saveVCard(String? label, String vCard) async {
    final html.Blob blob = html.Blob(<String>[vCard]);
    final String url = html.Url.createObjectUrlFromBlob(blob);
    final html.AnchorElement _ = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download =
          '${(label?.trim().isEmpty ?? true) ? DateTime.now().toIso8601String() : label!.trim()}.vcf'
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
