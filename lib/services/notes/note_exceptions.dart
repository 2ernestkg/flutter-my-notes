class NotesInitializationFailure implements Exception {
  final String message;
  NotesInitializationFailure([this.message = 'Could not fetch all your notes']);
}

class NoteDeleteFailure implements Exception {
  final String message;
  NoteDeleteFailure([this.message = 'Could not delete the note']);
}

class NoteUpdateFailure implements Exception {
  final String message;
  NoteUpdateFailure([this.message = 'Could not update the note']);
}
