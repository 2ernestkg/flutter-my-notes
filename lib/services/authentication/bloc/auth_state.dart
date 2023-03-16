import 'package:flutter/foundation.dart';
import 'package:mynotes/services/authentication/authentication.dart';
import 'package:mynotes/services/authentication/authentication_exceptions.dart';

@immutable
class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({required this.isLoading, this.loadingText});
}

class UnauthenticatedState extends AuthState {
  final AuthenticationException? throwable;
  const UnauthenticatedState(
      {required super.isLoading, super.loadingText, this.throwable});
}

class AuthenticationNeedsRegistrationState extends AuthState {
  final AuthenticationException? throwable;
  const AuthenticationNeedsRegistrationState(
      {required super.isLoading, super.loadingText, this.throwable});
}

class AuthenticatedState extends AuthState {
  final Authentication authentication;

  const AuthenticatedState(
      {required this.authentication,
      required super.isLoading,
      super.loadingText});
}

class AuthenticationNeedsVerificationState extends AuthState {
  const AuthenticationNeedsVerificationState(
      {required super.isLoading, super.loadingText});
}
