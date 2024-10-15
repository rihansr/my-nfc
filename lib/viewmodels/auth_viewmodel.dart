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
  TextEditingController? resetCodeController;

  AuthViewModel.claim(this._context)
      : usernameController = TextEditingController();

  AuthViewModel.signIn(this._context)
      : usernameController = TextEditingController(),
        passwordController = TextEditingController();

  AuthViewModel.signUp(this._context, [String? uid])
      : usernameController = TextEditingController(text: uid),
        emailController = TextEditingController(),
        passwordController = TextEditingController(),
        confirmPassController = TextEditingController();

  AuthViewModel.forgetPass(this._context)
      : emailController = TextEditingController();

  AuthViewModel.resetPass(this._context, [Map<String, dynamic>? params])
      : emailController = TextEditingController(text: params?['email']),
        resetCodeController =
            TextEditingController(text: params?['reset_code']),
        passwordController = TextEditingController(),
        confirmPassController = TextEditingController();

  Future<void> claimNow() async {
    if (!validate(formKey)) return;
    _context.pushNamed(
      Routes.signUp,
      queryParameters: {'username': usernameController?.text ?? ''},
    );
  }

  Future<void> login() async {
    if (!validate(formKey)) return;
    _context.goNamed(
      Routes.design,
      pathParameters: {'username': usernameController?.text ?? ''},
    );
  }

  Future<void> register() async {
    if (!validate(formKey)) return;
    _context.goNamed(
      Routes.design,
      pathParameters: {'username': usernameController?.text ?? ''},
    );
  }

  Future<void> resetEmail() async {
    if (!validate(formKey)) return;
    _context.canPop()
        ? _context.pop()
        : _context.pushReplacementNamed(Routes.signIn);
  }

  Future<void> passwordReset() async {
    if (!validate(formKey)) return;
    _context.canPop()
        ? _context.pop()
        : _context.pushReplacementNamed(Routes.signIn);
  }

  @override
  void dispose() {
    usernameController?.dispose();
    emailController?.dispose();
    passwordController?.dispose();
    confirmPassController?.dispose();
    resetCodeController?.dispose();
    super.dispose();
  }
}
