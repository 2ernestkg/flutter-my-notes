import 'package:flutter/material.dart';
import 'package:mynotes/services/authentication/authentication_service.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text("Please verify your email address"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ElevatedButton(
              onPressed:() async {
                await AuthenticationService().sendEmailVerificationCode();
              },
              child: const Text('Send email'),
            ),
          ),
        ],
      ),
    );
  }
}
