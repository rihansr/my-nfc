import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../shared/dimens.dart';
import '../../shared/strings.dart';
import '../../utils/validator.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/input_field_widget.dart';

class ResetPassView extends StatelessWidget {
  final Map<String, dynamic>? params;
  const ResetPassView({super.key, this.params});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return LayoutBuilder(
      builder: (context, constraints) =>
          ChangeNotifierProvider<AuthViewModel>.value(
        value: AuthViewModel.resetPass(context, params),
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
                        string.setNewPassword,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 36,
                        ),
                        textAlign: TextAlign.center,
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
                            controller: controller.passwordController,
                            hint: string.newPasswordHint,
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
                          InputField(
                            controller: controller.confirmPassController,
                            hint: string.newConfirmPasswordHint,
                            borderRadius: 12,
                            autoValidate: controller.enabledAutoValidate,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                            validator: (value) => validator.validatePassword(
                              value,
                              field: string.passwordHint,
                              matchValue: controller.passwordController?.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Button(
                      shape: BoxShape.rectangle,
                      radius: 12,
                      label: string.submit,
                      fillColor: theme.primaryColorLight,
                      fontColor: theme.colorScheme.onTertiary,
                      fontWeight: FontWeight.w500,
                      padding: const EdgeInsets.all(18),
                      onPressed: () => controller.passwordReset(),
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
