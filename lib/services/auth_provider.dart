import 'authentication.dart';

abstract class AuthProvider {
  Future<Authentication> login({required String username, required String password});
}
