import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routes/routes.dart';
import 'base_viewmodel.dart';

class AuthViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  final BuildContext _context;
  TextEditingController? usernameController;
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? confirmPassController;

  AuthViewModel.claim(this._context)
      : usernameController = TextEditingController();

  AuthViewModel.signIn(this._context)
      : emailController = TextEditingController(),
        passwordController = TextEditingController();

  AuthViewModel.signUp(this._context, [String? uid])
      : usernameController = TextEditingController(text: uid),
        emailController = TextEditingController(),
        passwordController = TextEditingController(),
        confirmPassController = TextEditingController();

  Future<void> claimNow() async {
    if (formKey.currentState?.validate() ?? false) {
      _context.goNamed(Routes.signUp, queryParameters: {'url': usernameController?.text ?? ''});
    }
  }

  @override
  void dispose() {
    usernameController?.dispose();
    emailController?.dispose();
    passwordController?.dispose();
    confirmPassController?.dispose();
    super.dispose();
  }
}
