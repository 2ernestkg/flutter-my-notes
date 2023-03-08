import 'package:mynotes/services/notes/note.dart';

abstract class NoteProvider {
  Future<Iterable<Note>> getUserNotes(String userId);
  Future<Note> createNote(String userId, String text);
  Future<void> delete(String noteId);
  Future<Note> update(String noteId, String text);
  Future<void> close();
}
