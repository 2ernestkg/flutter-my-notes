import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/notes/cloud/cloud_constants.dart';
import 'package:mynotes/services/notes/note.dart';
import 'package:mynotes/services/notes/note_exceptions.dart';
import 'package:mynotes/services/notes/note_provider.dart';

class CloudProvider extends NoteProvider {
  factory CloudProvider() => _instance;
  static final CloudProvider _instance = CloudProvider._privateConstructor();
  CloudProvider._privateConstructor();

  final documentDirectory = FirebaseFirestore.instance.collection('notes');

  @override
  Future<Note> createNote(String userId, String text) async {
    try {
      final document = await documentDirectory.add({
        userIdFieldName: userId,
        textFieldName: text,
      });

      final snapshot = await document.get();
      return Note(
        id: snapshot.id,
        text: snapshot.data()?[textFieldName] as String,
      );
    } catch (e) {
      throw NoteCreateFailure('Could not create note in cloud');
    }
  }

  @override
  Future<void> delete(String noteId) async {
    try {
      await documentDirectory.doc(noteId).delete();
    } catch (e) {
      throw NoteDeleteFailure('Could not delete note with id $noteId');
    }
  }

  @override
  Future<Iterable<Note>> getUserNotes(String userId) async {
    try {
      return await documentDirectory
          .where(userIdFieldName, isEqualTo: userId)
          .get()
          .then(
            (value) => value.docs.map((doc) => Note.fromSnapshot(doc)),
          );
    } catch (e) {
      throw NotesInitializationFailure('Could not fetch notes of user $userId');
    }
  }

  @override
  Future<Note> update(String noteId, String text) async {
    try {
      await documentDirectory.doc(noteId).update({textFieldName: text});
      return Note(id: noteId, text: text);
    } catch (e) {
      throw NoteUpdateFailure('Could not update note $noteId');
    }
  }

  @override
  Future<void> close() {
    return Future.value();
  }
}
