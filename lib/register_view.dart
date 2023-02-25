import 'package:flutter/material.dart';
import 'package:mynotes/common/notifications.dart';
import 'package:mynotes/routes.dart';
import 'package:mynotes/services/authentication/authentication_exceptions.dart';
import 'package:mynotes/services/authentication/authentication_service.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final AuthenticationService authService = AuthenticationService();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Center(
        child: Form(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(hintText: 'Enter email'),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 8, vertical: 10),
                  child: TextFormField(
                    controller: _password,
                    decoration:
                        const InputDecoration(hintText: 'Enter password'),
                    obscureText: true,
                    enableSuggestions: false,
                  )),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final String email = _email.text;
                    final String password = _password.text;

                    await authService.register(
                      email: email,
                      password: password,
                    );
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.loginRoute,
                      (route) => false,
                    );
                  } on UserAlreadyExistsException {
                    showErrorMessage(context, 'Registration',
                        'User with given email already exists');
                  } on WeakPasswordException {
                    showErrorMessage(context, 'Registration',
                        'Please enter a strong password');
                  } on AuthenticationException {
                    showErrorMessage(context, 'Registration',
                        'Could not register, please try again');
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
