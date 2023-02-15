import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/login_view.dart';

class MyNotesUI extends StatelessWidget {
  const MyNotesUI({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
        if (snapshot.hasData) {
          return LoginView();
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
