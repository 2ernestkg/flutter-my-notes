import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mynotes/services/notes/cloud/cloud_constants.dart';
import 'package:mynotes/services/notes/database/constants.dart';

@immutable
class Note {
  final String id;
  final String text;

  const Note({required this.id, required this.text});

  Note.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        text = snapshot.data()[textFieldName];

  Note.fromDBRow(Map<String, Object?> noteRow)
      : id = (noteRow[idColumn] as int).toString(),
        text = noteRow[textColumn] as String;
}
