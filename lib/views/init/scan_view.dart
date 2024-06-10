import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../routes/routes.dart';
import '../../services/nfc_service.dart';
import '../../shared/dimens.dart';
import '../../shared/drawables.dart';
import '../../shared/strings.dart';
import '../../shared/styles.dart';
import '../../utils/validator.dart';
import '../../widgets/button_widget.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
    super.initState();
  }

  _initialize() {
    NFC.instance.read(
      callback: (ndef, data) {
        String? url = data['records']?[0];
        if (url != null &&
            validator.validateUrl(url) == null &&
            url.contains('touchtie.com')) {
          String username = url.split('/').last.trim();
          username.isEmpty
              ? style.showToast(string.wrongNfcCard)
              : {
                  NFC.instance.stop(),
                  context.goNamed(
                    Routes.design,
                    pathParameters: {'username': username},
                  )
                };
        } else {
          style.showToast(string.wrongNfcCard);
        }
      },
    );
  }

  @override
  void dispose() {
    NFC.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          Button(
            label: string.login,
            fontWeight: FontWeight.bold,
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(16),
            borderTint: Colors.transparent,
            onPressed: () => context.pushNamed(Routes.signIn),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Align(
            alignment: Alignment.topCenter,
            child: Lottie.asset(
              drawable.scanning,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            string.scanCard,
            textAlign: TextAlign.center,
            style: theme.textTheme.displayLarge,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 52),
            child: Text(
              string.holdYourCard,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: dimen.bottom(24, false)),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: string.havingTrouble,
                style: theme.textTheme.bodyMedium,
              ),
              const TextSpan(text: " "),
              TextSpan(
                text: string.tryAgain,
                style: theme.textTheme.headlineMedium,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    HapticFeedback.lightImpact();
                    NFC.instance.stop();
                    _initialize();
                  },
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
