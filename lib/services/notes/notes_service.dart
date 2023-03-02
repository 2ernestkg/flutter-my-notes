import 'dart:async';

import 'package:mynotes/services/authentication/authentication_service.dart';
import 'package:mynotes/services/notes/database/database_note_provider.dart';
import 'package:mynotes/services/notes/database/exceptions.dart';
import 'package:mynotes/services/notes/note.dart';

class NoteService {
  List<Note> cache = [];
  final _auth = AuthenticationService().auth;
  final _notesProvider = DatabaseNoteProvider();
  late final StreamController<Iterable<Note>> _noteStreamController;

  static final NoteService _instance = NoteService._privateConstructor();
  NoteService._privateConstructor() {
    _noteStreamController =
        StreamController<Iterable<Note>>.broadcast(onListen: () {
      _noteStreamController.sink.add(cache);
    });
  }
  factory NoteService() => _instance;

  Stream<Iterable<Note>> get notes => _noteStreamController.stream;

  Future<void> initialize() async {
    try {} on DatabaseException catch (e) {
      throw NotesInitializationFailure('Could fetch all notes from database');
    }
    Iterable<Note> userNotes =
        await _notesProvider.getUserNotes(_auth.username);
    cache = userNotes.toList();
    _noteStreamController.add(userNotes);
  }

  Future<Note> createNote(String text) async {
    Note newNote = await _notesProvider.createNote(_auth.username, text);
    cache.add(newNote);
    _noteStreamController.add(cache);
    return newNote;
  }

  Future<void> deleteNote(String id) async {
    await _notesProvider.delete(id);
    cache.removeWhere((note) => note.id == id);
    _noteStreamController.add(cache);
  }

  Future<Note> updateNote(String id, String text) async {
    final Note updated = await _notesProvider.update(id, text);
    cache.removeWhere((note) => note.id == id);
    _noteStreamController.add(cache);
    return updated;
  }

  Future<void> close() async {
    _notesProvider.close();
  }
}
