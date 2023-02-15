import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../common/notifications.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextField(
        keyboardType: TextInputType.emailAddress,
        controller: _email,
        enableSuggestions: false,
      ),
      TextField(
        controller: _password,
        enableSuggestions: false,
        obscureText: true,
      ),
      TextButton.icon(
        icon: const Icon(Icons.login),
        label: const Text('Login'),
        onPressed: () async {
          String emailAddress = _email.text;
          String password = _password.text;
          try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: emailAddress,
              password: password
            );
          } on FirebaseAuthException catch(e) {
            if (e.code == 'user-not-found') {
              showErrorMessage("Authentication failure", 'User with email $emailAddress not found');
            } else if (e.code == 'wrong-password') {
              showErrorMessage("Authentication failure", 'Entered wrong password');
            }
          }
        }),
    ]);
  }
}
