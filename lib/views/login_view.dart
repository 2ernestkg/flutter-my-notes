import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../common/notifications.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _email,
                  enableSuggestions: false,
                  validator: (value) {
                    if (value == null || !EmailValidator.validate(value)) {
                      return "Please enter valid email";
                    }
                    return null;
                  })),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: TextFormField(
                  controller: _password,
                  enableSuggestions: false,
                  obscureText: true,
                  validator: (value) {
                    if (value == null) {
                      return "Please enter a password";
                    }
                    return null;
                  })),
          TextButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Login'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String emailAddress = _email.text;
                  String password = _password.text;
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailAddress,
                      password: password,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      showErrorMessage(context, "Authentication failure",
                          'User with email $emailAddress not found');
                    } else if (e.code == 'wrong-password') {
                      showErrorMessage(context, "Authentication failure",
                          'Entered wrong password');
                    } else {
                      showErrorMessage(context, "Authentication failure",
                          e.message ?? "Unknown");
                    }
                  }
                }
              }),
        ]));
  }
}
