import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/authentication/authentication_service.dart';
import 'package:mynotes/services/authentication/bloc/auth_bloc.dart';
import 'package:mynotes/services/authentication/bloc/auth_event.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email Address'),
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text("Please verify your email address"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ElevatedButton(
                onPressed: () async {
                  await AuthenticationService().sendEmailVerificationCode();
                },
                child: const Text('Send email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ElevatedButton(
                onPressed: () async {
                  context
                      .read<AuthBloc>()
                      .add(const SendValidationEmailEvent());
                },
                child: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
