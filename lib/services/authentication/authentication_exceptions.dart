class AuthenticationException implements Exception {
  final String message;
  const AuthenticationException(this.message);
}

class WeakPasswordException extends AuthenticationException {
  WeakPasswordException([String message = 'Try to enter strong password'])
      : super(message);
}

class UserAlreadyExistsException extends AuthenticationException {
  UserAlreadyExistsException(
      [String message = 'User with the same username already exists'])
      : super(message);
}

class InvalidEmailException extends AuthenticationException {
  InvalidEmailException(
      [String message = 'You entered wrong email address, please check'])
      : super(message);
}

class UserNotFoundException extends AuthenticationException {
  UserNotFoundException([String message = 'User with given username not found'])
      : super(message);
}

class UserIsNotEnabledException extends AuthenticationException {
  UserIsNotEnabledException([String message = 'User account is not enabled'])
      : super(message);
}

class WrongPasswordException extends AuthenticationException {
  WrongPasswordException([String message = 'You entered wrong password'])
      : super(message);
}

class UserIsNotLoggedInException extends AuthenticationException {
  UserIsNotLoggedInException([String message = 'You must be logged in first'])
      : super(message);
}
