import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../configs/app_config.dart';
import '../../routes/routes.dart';
import '../../shared/dimens.dart';
import '../../shared/strings.dart';
import '../../utils/validator.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/input_field_widget.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return LayoutBuilder(
      builder: (context, constraints) =>
          ChangeNotifierProvider<AuthViewModel>.value(
        value: AuthViewModel.signIn(context),
        child: Consumer<AuthViewModel>(
          builder: (context, controller, _) => Scaffold(
            appBar: kIsWeb ? null : AppBar(automaticallyImplyLeading: true),
            body: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: dimen.maxMobileWidth,
                ),
                padding: EdgeInsets.fromLTRB(16, 0, 16, dimen.bottom(16)),
                alignment: isMobile ? null : Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text(
                        string.signInNow,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 36,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(
                          string.signInSubtitle,
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InputField(
                            controller: controller.usernameController,
                            hint: string.usernameHint.toLowerCase(),
                            borderRadius: 12,
                            autoValidate: controller.enabledAutoValidate,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
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
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            validator: (value) => validator.validateField(
                              value,
                              field: string.passwordHint,
                              minLength: 3,
                            ),
                          ),
                          /*
                          InputField(
                            controller: controller.emailController,
                            hint: string.emailHint,
                            borderRadius: 12,
                            autoValidate: controller.enabledAutoValidate,
                            keyboardType: TextInputType.emailAddress,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                            validator: (value) =>
                                validator.validateEmail(value),
                          ),
                          */
                          InputField(
                            controller: controller.passwordController,
                            hint: string.passwordHint,
                            borderRadius: 12,
                            autoValidate: controller.enabledAutoValidate,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                            validator: (value) => validator.validatePassword(
                              value,
                              field: string.passwordHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Button(
                      shape: BoxShape.rectangle,
                      radius: 12,
                      label: string.signIn,
                      fillColor: theme.primaryColorLight,
                      fontColor: theme.colorScheme.onTertiary,
                      fontWeight: FontWeight.w500,
                      padding: const EdgeInsets.all(18),
                      onPressed: () => controller.login(),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        text: string.notHaveAnAccount,
                        style: theme.textTheme.bodySmall,
                        children: [
                          TextSpan(
                            text: string.createOne,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.primaryColorLight,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.pushNamed(Routes.signUp),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () => context.pushNamed(Routes.forgetPass),
                      child: Text(
                        string.forgotPassword,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
