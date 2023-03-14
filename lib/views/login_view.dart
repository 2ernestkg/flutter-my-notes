import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/common/dialogs.dart';
import 'package:mynotes/services/authentication/authentication_service.dart';
import 'package:mynotes/services/authentication/bloc/auth_bloc.dart';
import 'package:mynotes/services/authentication/bloc/auth_event.dart';
import 'package:mynotes/services/authentication/bloc/auth_state.dart';

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
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is! UnauthenticatedState) {
            return;
          }
          final throwable = state.throwable;
          if (throwable != null) {
            await showErrorMessage(context, 'Log In', throwable.message);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Login"),
            ),
            body: Form(
                key: _formKey,
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _email,
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null ||
                                !EmailValidator.validate(value)) {
                              return "Please enter valid email";
                            }
                            return null;
                          })),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
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
                          context.read<AuthBloc>().add(LogInEvent(
                                email: emailAddress,
                                password: password,
                              ));
                        }
                      }),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(const ShouldRegisterEvent());
                    },
                    child: const Text('Register'),
                  ),
                ]))));
  }
}
