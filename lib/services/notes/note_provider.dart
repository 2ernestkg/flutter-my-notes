import 'package:mynotes/services/notes/note.dart';

abstract class NoteProvider {
  Future<Iterable<Note>> getUserNotes(String uid);
  Future<Note> createNote(String uid, String text);
  Future<void> delete(String noteId);
  Future<Note> update(String noteId, String text);
}
