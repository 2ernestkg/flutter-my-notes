abstract class Authentication {
  String get username;
  bool get isAuthenticated;
  bool get isEmailVerified;
}

class UsernameAndPasswordAuthentication extends Authentication {
  final String username;
  final bool isAuthenticated;
  final bool isEmailVerified;

  UsernameAndPasswordAuthentication({required this.username, required this.isAuthenticated, required this.isEmailVerified});
 }

class AnonymousAuthentication extends Authentication {
  @override
  bool get isAuthenticated => false;

  @override
  bool get isEmailVerified => false;

  @override
  String get username => 'anonymous';
}
