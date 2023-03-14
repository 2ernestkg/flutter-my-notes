import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/routes.dart';
import 'package:mynotes/services/authentication/authentication_service.dart';
import 'package:mynotes/services/authentication/bloc/auth_bloc.dart';
import 'package:mynotes/views/notes/note_form.dart';

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
        Routes.notesForm: (context) => const NoteFormView(),
      },
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          return BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(AuthenticationService()),
            child: const AppContainer(),
          );
        },
      ),
    );
  }
}
