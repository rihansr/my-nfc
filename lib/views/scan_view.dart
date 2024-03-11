import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import '../services/nfc_service.dart';
import '../shared/dimens.dart';
import '../shared/drawables.dart';
import '../shared/strings.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  bool isWritable = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NFC.instance.read(
        callback: (ndef, data) {
          setState(() => isWritable = ndef.isWritable);
        },
      );
    });
    super.initState();
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
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: theme.scaffoldBackgroundColor,
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
      floatingActionButton: isWritable
          ? FloatingActionButton.extended(
              label: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.edit_outlined,
                        color: theme.colorScheme.onTertiary,
                        size: 16,
                      ),
                      alignment: PlaceholderAlignment.top,
                    ),
                    const TextSpan(text: " "),
                    TextSpan(
                      text: 'Write',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onTertiary,
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
              ),
              onPressed: () {
                isWritable = false;
                HapticFeedback.lightImpact();
              },
              backgroundColor: theme.colorScheme.tertiary,
              shape: const StadiumBorder(),
            )
          : null,
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
                    isWritable = false;
                    NFC.instance.read(
                      callback: (ndef, data) {
                        setState(() => isWritable = ndef.isWritable);
                      },
                    );
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
