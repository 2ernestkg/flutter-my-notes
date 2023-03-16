import 'dart:async';

import 'package:mynotes/services/notes/cloud/cloud_note_provider.dart';
import 'package:mynotes/services/notes/note.dart';
import 'package:mynotes/services/notes/note_provider.dart';

class NoteService {
  List<Note> cache = [];
  final NoteProvider _notesProvider = CloudProvider();
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

  Future<Iterable<Note>> getNotes(String userId) async {
    Iterable<Note> userNotes = await _notesProvider.getUserNotes(userId);
    cache = userNotes.toList();
    _notesStreamController.add(cache);
    return cache;
  }

  Future<Note> createNote(String userId, String text) async {
    Note newNote = await _notesProvider.createNote(userId, text);
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
    await _notesProvider.close();
  }
}
