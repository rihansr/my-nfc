import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:my_nfc/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../configs/app_config.dart';
import '../../shared/strings.dart';
import '../../utils/validator.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/input_field_widget.dart';

class ClaimPageView extends StatelessWidget {
  const ClaimPageView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return ChangeNotifierProvider<AuthViewModel>.value(
      value: AuthViewModel.claim(context),
      child: Consumer<AuthViewModel>(
        builder: (context, controller, _) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              string.appName,
              style: const TextStyle(height: 1),
            ),
            titleSpacing: 16,
            actions: [
              Button(
                label: string.login,
                fontWeight: FontWeight.bold,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(16),
                borderTint: Colors.transparent,
                onPressed: () => context.pushNamed(Routes.signIn),
              ),
              Button(
                label: string.signUpForFree,
                fontWeight: FontWeight.bold,
                fillColor: theme.colorScheme.primary,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(16),
                borderTint: Colors.white,
                onPressed: () => context.pushNamed(Routes.signUp),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Spacer(flex: 5),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: Text(
                    string.claimPageTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 34,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Text(
                      string.claimPageSubtitle,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                (() {
                  final input = Form(
                    key: controller.formKey,
                    child: InputField(
                      controller: controller.usernameController,
                      expanded: isMobile,
                      hint: string.usernameHint.toLowerCase(),
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.all(16),
                      borderRadius: 12,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          '${appConfig.configs['base']?['domain'] ?? ''}/',
                          maxLines: 1,
                          style: theme.textTheme.bodySmall?.copyWith(
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                      autoValidate: controller.enabledAutoValidate,
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 8, minHeight: 0),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                      validator: (value) =>
                          validator.validateField(value, minLength: 3),
                    ),
                  );
                  final button = Button(
                    label: string.claimYourPage,
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(16),
                    fillColor: theme.primaryColorLight,
                    fontColor: theme.colorScheme.onTertiary,
                    fontWeight: FontWeight.w500,
                    onPressed: () => controller.claimNow(),
                  );
                  return isMobile
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: input),
                            const SizedBox(width: 16),
                            button,
                          ],
                        )
                      : Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            input,
                            button,
                          ],
                        );
                }()),
                const Spacer(flex: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
