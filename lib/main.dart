import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/login_view.dart';
import 'package:mynotes/register_view.dart';
import 'package:mynotes/routes.dart';
import 'package:mynotes/views/main_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

import 'app_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        Routes.loginRoute: (context) => const LoginView(),
        Routes.registerRoute: (context) => const RegisterView(),
        Routes.notesRoute: (context) => const MainView(),
        Routes.verifyEmailRoute: (context) => const VerifyEmailView(),
      },
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const AppContainer();
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
