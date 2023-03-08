class DatabaseConnectionFailure extends DatabaseException {
  const DatabaseConnectionFailure()
      : super('Could not acquire database connection');
}

class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);
}
