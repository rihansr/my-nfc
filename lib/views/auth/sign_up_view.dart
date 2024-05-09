import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

class SignUpView extends StatelessWidget {
  final String? uid;
  const SignUpView({this.uid, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthViewModel>.value(
      value: AuthViewModel.signUp(context, uid),
      child: Consumer<AuthViewModel>(
          builder: (context, controller, _) => const Placeholder()),
    );
  }
}
