import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/authentication/authentication_exceptions.dart';
import 'package:mynotes/services/authentication/authentication_service.dart';
import 'package:mynotes/services/authentication/bloc/auth_event.dart';
import 'package:mynotes/services/authentication/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthenticationService authenticationService)
      : super(const UnauthenticatedState()) {
    on<LogOutEvent>((event, emit) async {
      await authenticationService.logout();
      emit(const UnauthenticatedState());
    });
    on<LogInEvent>((event, emit) async {
      try {
        final auth = await authenticationService.login(
          email: event.email,
          password: event.password,
        );
        emit(AuthenticatedState(auth));
      } on AuthenticationException catch (e) {
        emit(UnauthenticatedState(e));
      }
    });
    on<ShouldRegisterEvent>((event, emit) {
      emit(const AuthenticationNeedsRegistrationState());
    });
    on<RegisterEvent>((event, emit) async {
      try {
        final auth = await authenticationService.register(
          email: event.email,
          password: event.password,
        );
        if (!auth.isEmailVerified) {
          emit(const AuthenticationNeedsVerificationState());
          return;
        }
        emit(AuthenticatedState(auth));
      } on AuthenticationException catch (e) {
        emit(AuthenticationNeedsRegistrationState(e));
      }
    });
    on<SendValidationEmailEvent>((event, emit) async {
      try {
        await authenticationService.sendEmailVerificationCode();
        await authenticationService.logout();
        emit(const UnauthenticatedState());
      } on AuthenticationException catch (_) {
        emit(const AuthenticationNeedsVerificationState());
      }
    });
  }
}
