import 'authentication.dart';

abstract class AuthProvider {
  Future<Authentication> login({
    required String username,
    required String password,
  });
  Future<Authentication> createUser({
    required String username,
    required String password,
  });
  Future<void> logout();
  Future<void> sendEmailVerification();
}
