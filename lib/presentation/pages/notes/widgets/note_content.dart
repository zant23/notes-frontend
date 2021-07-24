import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/constants/palette.dart';
import 'package:notes/controlllers/notes/selected_note_controller.dart';
import 'package:notes/models/note.dart';

class NoteContent extends HookWidget {
  const NoteContent({Key? key}) : super(key: key);

  Future<void> saveNote(BuildContext context) async {
    final bool success =
        await context.read(selectedNoteProvider.notifier).save();
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Note saved'),
        duration: Duration(milliseconds: 500),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Coud not save note'),
        duration: Duration(milliseconds: 500),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Note? selectedNote = useProvider(selectedNoteProvider);
    if (selectedNote == null) {
      return Center(
        child: Text(
          'no note selected',
          style: TextStyle(fontSize: 20, color: kAccentColor),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _TitleEditor(note: selectedNote),
          Expanded(child: _NoteEditor(note: selectedNote)),
          TextButton(
              onPressed: () => saveNote(context),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 15),
              ))
        ],
      ),
    );
  }
}

class _TitleEditor extends StatelessWidget {
  final Note note;
  const _TitleEditor({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        key: ValueKey('${note.id}_title'),
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        initialValue: note.title,
        onChanged: (value) =>
            context.read(selectedNoteProvider.notifier).updateTitle(value),
        cursorColor: kPrimaryColor,
        decoration: const InputDecoration(
          hintText: 'Add a note title...',
          border: InputBorder.none,
          focusColor: kPrimaryColor,
        ));
  }
}

class _NoteEditor extends StatelessWidget {
  final Note note;
  const _NoteEditor({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey('${note.id}_description'),
      initialValue: note.description,
      onChanged: (value) {
        context.read(selectedNoteProvider.notifier).updateDescription(value);
      },
      cursorColor: kPrimaryColor,
      decoration: const InputDecoration(
        hintText: 'Add your note here...',
        border: InputBorder.none,
        focusColor: kPrimaryColor,
      ),
      keyboardType: TextInputType.multiline,
      maxLines: null,
    );
  }
}
