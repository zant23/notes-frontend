import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/controlllers/notes/notes_controller.dart';
import 'package:notes/controlllers/notes/selected_note_controller.dart';
import 'package:notes/models/note.dart';

class AddNoteIcon extends StatelessWidget {
  const AddNoteIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          final Note? newNote =
              await context.read(notesProvider.notifier).addNote();
          if (newNote != null) {
            context.read(selectedNoteProvider.notifier).select(newNote);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(milliseconds: 800),
                content: Text('New note was added')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                duration: Duration(milliseconds: 800),
                content: Text('Could not add new note')));
          }
        },
        icon: const Icon(
          Icons.add,
          size: 25,
        ));
  }
}
