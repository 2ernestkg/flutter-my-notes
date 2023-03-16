import 'package:flutter/material.dart';
import 'package:mynotes/common/context_extensions.dart';
import 'package:mynotes/services/authentication/authentication_service.dart';
import 'package:mynotes/services/notes/note.dart';
import 'package:mynotes/services/notes/note_service.dart';

class NoteFormView extends StatefulWidget {
  const NoteFormView({super.key});

  @override
  State<NoteFormView> createState() => _NoteFormViewState();
}

class _NoteFormViewState extends State<NoteFormView> {
  Note? _note;
  late final NoteService _noteService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _noteService = NoteService();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextIsNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _saveNoteIfTextIsNotEmpty() async {
    final note = _note;
    if (note != null && _textController.text.isNotEmpty) {
      await _noteService.updateNote(note.id, _textController.text);
    }
  }

  Future<void> _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (note != null && _textController.text.isEmpty) {
      await _noteService.deleteNote(note.id);
    }
  }

  Future<Note> _createOrGetNote(BuildContext context) async {
    final note = context.getArgument();
    if (note != null) {
      _note = note;
      _textController.text = note.text;
      return note;
    }

    final currentUserId = AuthenticationService().auth.id;
    final newNote = await _noteService.createNote(currentUserId, '');
    _note = newNote;
    return newNote;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form'),
      ),
      body: FutureBuilder(
        future: _createOrGetNote(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          //_setupTextControllerListener();
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Start typing your note',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
