import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../services/navigation_service.dart';
import '../../models/arguments_model.dart';

class WebContentView extends StatefulWidget {
  final Arguments<String> args;
  const WebContentView({super.key, required this.args});

  @override
  State<WebContentView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<WebContentView> {
  late final WebViewController controller;

  var loadingPercentage = 0;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) => setState(() => loadingPercentage = 0),
        onProgress: (progress) => setState(() => loadingPercentage = progress),
        onPageFinished: (url) => setState(() => loadingPercentage = 100),
      ))
      ..loadRequest(Uri.parse(widget.args.data));
    super.initState();
  }

  goBack() => controller
      .canGoBack()
      .then((canGoBack) => canGoBack ? controller.goBack() : context.pop());

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        title: widget.args.tag != null ? Text(widget.args.tag!) : null,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: goBack,
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
              backgroundColor: theme.colorScheme.onSecondary,
              color: theme.colorScheme.primary,
            ),
        ],
      ),
    );
  }
}
