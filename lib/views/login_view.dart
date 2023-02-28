import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/common/dialogs.dart';
import 'package:mynotes/routes.dart';
import 'package:mynotes/services/authentication/authentication_exceptions.dart';
import 'package:mynotes/services/authentication/authentication_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final authenticationService = AuthenticationService();
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Form(
            key: _formKey,
            child: Column(children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
                        await authenticationService.login(
                          email: emailAddress,
                          password: password,
                        );
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.notesRoute,
                          (route) => false,
                        );
                      } on UserNotFoundException {
                        showErrorMessage(context, 'Login',
                            'User with given email not found');
                      } on WrongPasswordException {
                        showErrorMessage(context, 'Login', 'Wrong password');
                      } on InvalidEmailException {
                        showErrorMessage(
                            context, 'Login', 'Invalid email address provided');
                      } on UserIsNotEnabledException {
                        showErrorMessage(
                            context, 'Login', 'User is not enabled');
                      } on AuthenticationException {
                        showErrorMessage(
                            context, 'Login', 'Could not authenticate');
                      }
                    }
                  }),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.registerRoute,
                    (route) => false,
                  );
                },
                child: const Text('Register'),
              ),
            ])));
  }
}
