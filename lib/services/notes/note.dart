import 'package:flutter/foundation.dart';

@immutable
class Note {
  final String id;
  final String text;

  const Note({required this.id, required this.text});
}
