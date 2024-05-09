import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthViewModel>.value(
      value: AuthViewModel.signIn(context),
      child: Consumer<AuthViewModel>(
        builder: (context, controller, _) => const Placeholder()
      ),
    );
  }
}