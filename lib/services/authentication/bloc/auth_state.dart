import 'package:flutter/foundation.dart';
import 'package:mynotes/services/authentication/authentication.dart';
import 'package:mynotes/services/authentication/authentication_exceptions.dart';

@immutable
class AuthState {
  const AuthState();
}

class UnauthenticatedState extends AuthState {
  final AuthenticationException? throwable;
  const UnauthenticatedState([this.throwable]);
}

class AuthenticationNeedsRegistrationState extends AuthState {
  final AuthenticationException? throwable;
  const AuthenticationNeedsRegistrationState([this.throwable]);
}

class AuthenticatedState extends AuthState {
  final Authentication authentication;

  const AuthenticatedState(this.authentication);
}

class AuthenticationNeedsVerificationState extends AuthState {
  const AuthenticationNeedsVerificationState();
}
