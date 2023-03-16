import 'package:flutter/foundation.dart';

@immutable
class AuthEvent {
  const AuthEvent();
}

class ShouldLoginEvent extends AuthEvent {
  const ShouldLoginEvent();
}

class ShouldRegisterEvent extends AuthEvent {
  const ShouldRegisterEvent();
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;

  const RegisterEvent({required this.email, required this.password});
}

class SendValidationEmailEvent extends AuthEvent {
  const SendValidationEmailEvent();
}

class LogInEvent extends AuthEvent {
  final String email;
  final String password;

  const LogInEvent({required this.email, required this.password});
}

class LogOutEvent extends AuthEvent {
  const LogOutEvent();
}
