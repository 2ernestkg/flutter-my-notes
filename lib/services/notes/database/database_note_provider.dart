import 'package:mynotes/services/notes/database/constants.dart';
import 'package:mynotes/services/notes/database/database_user.dart';
import 'package:mynotes/services/notes/database/exceptions.dart';
import 'package:mynotes/services/notes/note.dart';
import 'package:mynotes/services/notes/note_exceptions.dart';
import 'package:mynotes/services/notes/note_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseNoteProvider extends NoteProvider {
  Database? _db;

  factory DatabaseNoteProvider() => _instance;
  static final DatabaseNoteProvider _instance =
      DatabaseNoteProvider._privateConstructor();
  DatabaseNoteProvider._privateConstructor();

  @override
  Future<Note> createNote(String userId, String text) async {
    try {
      final db = await _getDatabaseConnection();
      final user = await _getOrCreateUser(userId);
      final int noteId = await db.insert(noteTable, {
        userIdColumn: user.id,
        textColumn: text,
      });
      return Note(id: noteId.toString(), text: text);
    } catch (e) {
      throw NoteCreateFailure('Could not create note, cause $e');
    }
  }

  @override
  Future<void> delete(String noteId) async {
    try {
      final db = await _getDatabaseConnection();
      int cnt = await db.delete(noteTable, where: "id=?", whereArgs: [noteId]);
      if (cnt == 0) {
        throw NoteDeleteFailure('Could not delete note with id $noteId');
      }
    } catch (e) {
      throw NoteDeleteFailure('Could not delete note with id $noteId');
    }
  }

  @override
  Future<Iterable<Note>> getUserNotes(String userId) async {
    try {
      final db = await _getDatabaseConnection();
      final currentUser = await _getOrCreateUser(userId);
      final notes = await db
          .query(noteTable, where: 'user_id=?', whereArgs: [currentUser.id]);
      return notes.map((noteRow) => Note.fromDBRow(noteRow)).toList();
    } catch (e) {
      throw NotesInitializationFailure('Could get notes for user $userId');
    }
  }

  @override
  Future<Note> update(String noteId, String text) async {
    try {
      final db = await _getDatabaseConnection();
      final int id = int.parse(noteId);
      final int updateCount = await db.update(noteTable, {textColumn: text},
          where: 'id=?', whereArgs: [id]);
      if (updateCount == 0) {
        throw NoteUpdateFailure('Could not update note with id $noteId');
      }
      return Note(id: noteId, text: text);
    } catch (e) {
      throw NoteUpdateFailure('Could not update note with id $noteId');
    }
  }

  Future<DatabaseUser> _getOrCreateUser(String uid) async {
    final db = await _getDatabaseConnection();
    final resultList = await db.query(userTable,
        limit: 1, where: 'username=?', whereArgs: [uid.toLowerCase()]);

    if (resultList.isNotEmpty) {
      return DatabaseUser.fromRow(resultList.first);
    }
    int userId =
        await db.insert(userTable, {usernameColumn: uid.toLowerCase()});
    return DatabaseUser(
      id: userId,
      username: uid,
    );
  }

  Future<Database> _getDatabaseConnection() async {
    Database? db = _db;
    if (db == null) {
      db = await _openDatabase();
      _db = db;
    }
    return db;
  }

  Future<Database> _openDatabase() async {
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);

      //create user table
      db.execute(createUserTable);
      //create notes table
      db.execute(createNoteTable);
      return db;
    } on MissingPlatformDirectoryException {
      throw const DatabaseConnectionFailure();
    }
  }

  @override
  Future<void> close() async {
    final db = _db;
    if (db == null) {
      return;
    }
    await db.close();
    _db = null;
  }
}
