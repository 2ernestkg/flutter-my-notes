import 'dart:async';

import 'package:mynotes/services/authentication/authentication_service.dart';
import 'package:mynotes/services/notes/database/database_note_provider.dart';
import 'package:mynotes/services/notes/note.dart';

class NoteService {
  List<Note> cache = [];
  final _auth = AuthenticationService().auth;
  final _notesProvider = DatabaseNoteProvider();
  late final StreamController<List<Note>> _notesStreamController;

  static final NoteService _instance = NoteService._privateConstructor();
  NoteService._privateConstructor() {
    _notesStreamController =
        StreamController<List<Note>>.broadcast(onListen: () {
      _notesStreamController.sink.add(cache);
    });
  }
  factory NoteService() => _instance;

  Stream<List<Note>> get notes => _notesStreamController.stream;

  Future<Iterable<Note>> getUserNotes() async {
    Iterable<Note> userNotes =
        await _notesProvider.getUserNotes(_auth.username);
    cache = userNotes.toList();
    _notesStreamController.add(cache);
    return cache;
  }

  Future<Note> createNote(String text) async {
    Note newNote = await _notesProvider.createNote(_auth.username, text);
    cache.add(newNote);
    _notesStreamController.add(cache);
    return newNote;
  }

  Future<void> deleteNote(String id) async {
    await _notesProvider.delete(id);
    cache.removeWhere((note) => note.id == id);
    _notesStreamController.add(cache);
  }

  Future<Note> updateNote(String id, String text) async {
    Note updated = await _notesProvider.update(id, text);
    cache.removeWhere((note) => note.id == id);
    cache.add(updated);
    _notesStreamController.add(cache);
    return updated;
  }

  Future<void> close() async {
    _notesProvider.close();
  }
}
