abstract class Authentication {
  String get id;
  String get username;
  bool get isAuthenticated;
  bool get isEmailVerified;
}

class UsernameAndPasswordAuthentication extends Authentication {
  @override
  final String id;
  @override
  final String username;
  @override
  final bool isAuthenticated;
  @override
  final bool isEmailVerified;

  UsernameAndPasswordAuthentication(
      {required this.id,
      required this.username,
      required this.isAuthenticated,
      required this.isEmailVerified});
}

class AnonymousAuthentication extends Authentication {
  @override
  String get id =>
      throw Exception('Anonymouse authentication does not have an id');
  @override
  bool get isAuthenticated => false;

  @override
  bool get isEmailVerified => false;

  @override
  String get username => 'anonymous';
}
