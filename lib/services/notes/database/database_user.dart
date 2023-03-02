import 'package:flutter/foundation.dart';
import 'package:mynotes/services/notes/database/constants.dart';

@immutable
class DatabaseUser {
  final int id;
  final String username;

  const DatabaseUser({required this.id, required this.username});

  DatabaseUser.fromRow(row)
      : id = row[idColumn] as int,
        username = row[usernameColumn] as String;
}
