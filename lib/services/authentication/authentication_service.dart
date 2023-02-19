import 'package:mynotes/services/authentication/auth_provider.dart';
import 'package:mynotes/services/authentication/auth_provider/firebase_auth_provider.dart';
import 'package:mynotes/services/authentication/authentication.dart';

class AuthenticationService {
  final Authentication _auth;
  final AuthProvider _provider;

  factory  AuthenticationService() => _instance;
  static final AuthenticationService _instance = AuthenticationService._privateConstructor(FirebaseAuthProvider());

  AuthenticationService._privateConstructor(this._provider) : _auth = AnonymousAuthentication();

  Authentication get auth => _auth;

  Future<Authentication> login({
    required String email,
    required String password,
  }) {
    return _provider.login(username: email, password: password);
  }

  Future<Authentication> register({
    required String email,
    required String password,
  }) {
    return _provider.createUser(username: email, password: password);
  }

  Future<void> logout() {
    return _provider.logout();
  }

  Future<void> sendEmailVerificationCode() {
    return _provider.sendEmailVerification();
  }
}
