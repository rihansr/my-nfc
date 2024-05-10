import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../routes/routes.dart';
import '../../shared/dimens.dart';
import '../../shared/strings.dart';
import '../../utils/validator.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/input_field_widget.dart';

class ForgetPassView extends StatelessWidget {
  const ForgetPassView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return LayoutBuilder(
      builder: (context, constraints) =>
          ChangeNotifierProvider<AuthViewModel>.value(
        value: AuthViewModel.forgetPass(context),
        child: Consumer<AuthViewModel>(
          builder: (context, controller, _) => Scaffold(
            appBar: kIsWeb ? null : AppBar(automaticallyImplyLeading: true),
            body: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: dimen.maxMobileWidth,
                  minHeight: constraints.maxHeight,
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
                        string.resetPassword,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 36,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          string.passwordResetSubtitle,
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: controller.formKey,
                      child: InputField(
                        controller: controller.emailController,
                        hint: string.emailHint,
                        borderRadius: 12,
                        autoValidate: controller.enabledAutoValidate,
                        keyboardType: TextInputType.emailAddress,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                        validator: (value) => validator.validateEmail(value),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Button(
                      shape: BoxShape.rectangle,
                      radius: 12,
                      label: string.resetPassword,
                      fillColor: theme.primaryColorLight,
                      fontWeight: FontWeight.w500,
                      fontColor: theme.colorScheme.onTertiary,
                      padding: const EdgeInsets.all(18),
                      onPressed: () => controller.resetEmail(),
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
                              ..onTap = () =>
                                  context.pushReplacementNamed(Routes.signUp),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
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
