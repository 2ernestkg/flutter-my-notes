import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/common/dialogs.dart';
import 'package:mynotes/routes.dart';
import 'package:mynotes/services/authentication/authentication_service.dart';
import 'package:mynotes/services/authentication/bloc/auth_bloc.dart';
import 'package:mynotes/services/authentication/bloc/auth_event.dart';
import 'package:mynotes/services/notes/note.dart';
import 'package:mynotes/services/notes/note_service.dart';
import 'package:mynotes/views/notes/note_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  final _userId = AuthenticationService().auth.id;
  final _noteService = NoteService();

  @override
  void dispose() {
    _noteService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes'), actions: [
        IconButton(
          icon: const Icon(
            Icons.add,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.notesForm);
          },
        ),
        PopupMenuButton<MenuAction>(itemBuilder: (context) {
          return const [
            PopupMenuItem<MenuAction>(
              value: MenuAction.logout,
              child: Text('Log Out'),
            )
          ];
        }, onSelected: (value) async {
          if (value == MenuAction.logout) {
            final isLogOutConfirmed = await showLogOutDialog(context) ?? true;
            if (!isLogOutConfirmed) {
              return;
            }
            context.read<AuthBloc>().add(const LogOutEvent());
          }
        }),
      ]),
      body: FutureBuilder(
        future: _noteService.getNotes(_userId),
        builder: (builder, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return StreamBuilder(
            stream: _noteService.notes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final notes = snapshot.data as List<Note>;
              return NoteListView(
                notes: notes,
                onDelete: (note) async {
                  await _noteService.deleteNote(note.id);
                },
                onTap: (note) {
                  Navigator.of(context).pushNamed(
                    Routes.notesForm,
                    arguments: note,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

enum MenuAction { logout }
