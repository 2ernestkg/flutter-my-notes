import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:mynotes/common/dialogs.dart';
import 'package:mynotes/routes.dart';
import 'package:mynotes/services/authentication/authentication_service.dart';
import 'package:mynotes/views/verify_email_view.dart';

import '../services/authentication/authentication.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final _authenticationService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    final Authentication currentUser = _authenticationService.auth;
    if (!currentUser.isEmailVerified) {
      developer.log('${currentUser.isEmailVerified} email not yet verified');
      return const VerifyEmailView();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Notes'), actions: [
        PopupMenuButton<MenuAction>(itemBuilder: (context) {
          return const [
            PopupMenuItem<MenuAction>(
              value: MenuAction.logout,
              child: Text('Log Out'),
            )
          ];
        }, onSelected: (value) async {
          if (value == MenuAction.logout) {
            final isLogOutConfirmed = await showLogOutDialog(context) ?? true;
            if (!isLogOutConfirmed) {
              return;
            }
            await _authenticationService.logout();
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.loginRoute,
              (_) => false,
            );
          }
        }),
      ]),
      body: const Text('notes'),
    );
  }
}

enum MenuAction { logout }
