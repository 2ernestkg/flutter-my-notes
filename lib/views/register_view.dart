import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/common/dialogs.dart';
import 'package:mynotes/services/authentication/authentication_service.dart';
import 'package:mynotes/services/authentication/bloc/auth_bloc.dart';
import 'package:mynotes/services/authentication/bloc/auth_event.dart';
import 'package:mynotes/services/authentication/bloc/auth_state.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is! AuthenticationNeedsRegistrationState) {
          return;
        }
        final throwable = state.throwable;
        if (throwable == null) {
          return;
        }
        await showErrorMessage(context, 'Registration', throwable.message);
      },
      child: Scaffold(
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
                    final String email = _email.text;
                    final String password = _password.text;

                    context
                        .read<AuthBloc>()
                        .add(RegisterEvent(email: email, password: password));
                  },
                  child: const Text('Register'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const ShouldLoginEvent());
                  },
                  child: const Text('Log In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
