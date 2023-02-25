import 'package:flutter/material.dart';
import 'package:mynotes/login_view.dart';
import 'package:mynotes/services/authentication/authentication.dart';
import 'package:mynotes/services/authentication/authentication_service.dart';
import 'package:mynotes/views/main_view.dart';

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
    return _currentUser.isAuthenticated ? const MainView() : const LoginView();
  }
}
