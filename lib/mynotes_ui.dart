import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/authentication/authentication.dart';
import 'package:mynotes/services/authentication/authentication_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

class AppContainer extends StatefulWidget {
  const AppContainer({super.key});

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  late final Authentication _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = AuthenticationService().auth;
  }

  @override
  Widget build(BuildContext context) {
    Widget view = const MainView();
    if (!_currentUser.isAuthenticated) {
     view = const LoginView();
    }
    return Material(type: MaterialType.card, child: view);
  }
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Main View');
  }
}
