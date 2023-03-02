class CouldNotUpdateNote extends DatabaseException {
  const CouldNotUpdateNote([super.message = 'Could not update note']);
}

class CouldNotDeleteNote extends DatabaseException {
  const CouldNotDeleteNote() : super("Could not delete a user note");
}

class DatabaseConnectionFailure extends DatabaseException {
  const DatabaseConnectionFailure()
      : super('Could not acquire database connection');
}

class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);
}
