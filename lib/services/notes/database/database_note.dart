import 'package:flutter/foundation.dart';
import 'package:mynotes/services/notes/database/constants.dart';

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String text;

  const DatabaseNote(
      {required this.id, required this.userId, required this.text});

  DatabaseNote.fromRow(Map<String, Object?> row)
      : id = row[idColumn] as int,
        userId = row[userIdColumn] as int,
        text = row[textColumn] as String;

  @override
  String toString() => ' Note [id=$id, userId=$userId, text=$text]';

  @override
  bool operator ==(covariant DatabaseNote other) => other.id == id;

  @override
  int get hashCode => id.hashCode;
}
