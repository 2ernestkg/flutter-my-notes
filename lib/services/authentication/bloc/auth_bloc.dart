import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/authentication/authentication_exceptions.dart';
import 'package:mynotes/services/authentication/authentication_service.dart';
import 'package:mynotes/services/authentication/bloc/auth_event.dart';
import 'package:mynotes/services/authentication/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthenticationService authenticationService)
      : super(const UnauthenticatedState(isLoading: false)) {
    on<ShouldLoginEvent>((event, emit) {
      emit(const UnauthenticatedState(isLoading: false));
    });
    on<LogOutEvent>((event, emit) async {
      emit(AuthenticatedState(
        authentication: AuthenticationService().auth,
        isLoading: true,
        loadingText: 'Logging out',
      ));
      try {
        await authenticationService.logout();
        emit(const UnauthenticatedState(isLoading: false));
      } on AuthenticationException catch (e) {
        emit(UnauthenticatedState(isLoading: false, throwable: e));
      }
    });
    on<LogInEvent>((event, emit) async {
      emit(const UnauthenticatedState(
          isLoading: true, loadingText: 'Logging in, please wait'));
      try {
        final auth = await authenticationService.login(
          email: event.email,
          password: event.password,
        );
        emit(AuthenticatedState(authentication: auth, isLoading: false));
      } on AuthenticationException catch (e) {
        emit(UnauthenticatedState(isLoading: false, throwable: e));
      }
    });
    on<ShouldRegisterEvent>((event, emit) {
      emit(const AuthenticationNeedsRegistrationState(isLoading: false));
    });
    on<RegisterEvent>((event, emit) async {
      emit(const UnauthenticatedState(
        isLoading: true,
        loadingText: 'Registering...',
      ));
      try {
        final auth = await authenticationService.register(
          email: event.email,
          password: event.password,
        );
        if (!auth.isEmailVerified) {
          emit(const AuthenticationNeedsVerificationState(isLoading: false));
          return;
        }
        emit(AuthenticatedState(authentication: auth, isLoading: false));
      } on AuthenticationException catch (e) {
        emit(AuthenticationNeedsRegistrationState(
            isLoading: false, throwable: e));
      }
    });
    on<SendValidationEmailEvent>((event, emit) async {
      emit(const AuthenticationNeedsVerificationState(
        isLoading: true,
        loadingText: 'Sending verification email, please check your inbox',
      ));
      try {
        await authenticationService.sendEmailVerificationCode();
        await authenticationService.logout();
        emit(const UnauthenticatedState(isLoading: false));
      } on AuthenticationException catch (_) {
        emit(const AuthenticationNeedsVerificationState(isLoading: false));
      }
    });
  }
}
