import 'package:flutter/material.dart';
import 'package:mynotes/common/dialogs.dart';
import 'package:mynotes/services/notes/note.dart';

typedef NoteCallback = void Function(Note note);

class NoteListView extends StatelessWidget {
  final List<Note> notes;
  final NoteCallback onDelete;
  final NoteCallback onTap;

  const NoteListView(
      {Key? key,
      required this.notes,
      required this.onDelete,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            onTap(note);
          },
          trailing: IconButton(
            onPressed: () async {
              final bool isDeleteConfirmed =
                  await showConfirmDeleteDialog(context) ?? false;
              if (isDeleteConfirmed) {
                onDelete(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
