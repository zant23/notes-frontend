import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/constants/palette.dart';
import 'package:notes/constants/style.dart';
import 'package:notes/controlllers/notes/notes_controller.dart';
import 'package:notes/controlllers/notes/selected_note_controller.dart';
import 'package:notes/models/note.dart';
import 'package:notes/presentation/widgets/loading_screen.dart';

class NotesTitleBar extends HookWidget {
  final Function(Note)? afterNoteSelected;
  const NotesTitleBar({Key? key, this.afterNoteSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Note>> notesAsync = useProvider(notesProvider);
    final Note? selectedNote = useProvider(selectedNoteProvider);
    final ScrollController _scrollController = useScrollController();

    return notesAsync.when(
        loading: () => const LoadingScreen(),
        error: (error, stacktrace) => const LoadingScreen(),
        data: (notes) => ListView.builder(
            controller: _scrollController,
            itemBuilder: (_, i) => _TitleTile(
                key: ValueKey(notes[i].id),
                title: notes[i].title,
                onNameChange: () {},
                onDelete: () {
                  context.read(notesProvider.notifier).deleteNote(notes[i].id!);
                  if (notes[i].id == selectedNote?.id) {
                    context.read(selectedNoteProvider.notifier).unSelect();
                  }
                },
                onSelect: () {
                  context.read(selectedNoteProvider.notifier).select(notes[i]);
                  if (afterNoteSelected != null) {
                    afterNoteSelected!(notes[i]);
                  }
                },
                isSelected: selectedNote?.id == notes[i].id),
            itemCount: notes.length));
  }
}

class _TitleTile extends HookWidget {
  final String title;
  final bool isSelected;
  final Function onSelect;
  final Function onDelete;
  final Function onNameChange;

  const _TitleTile({
    Key? key,
    required this.title,
    required this.onNameChange,
    required this.onDelete,
    required this.onSelect,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController =
        useTextEditingController();
    textEditingController.text = title;

    return SizedBox(
      height: MediaQuery.of(context).size.width > kMaxMobileWidth ? 50 : 60,
      child: Material(
        color: isSelected ? kAccentColor : kBackgroundColor,
        child: InkWell(
          onTap: () => onSelect(),
          onLongPress: () => onDelete(),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              title.isEmpty ? 'No Title' : title,
              style: TextStyle(
                  color: title.isEmpty
                      ? kPrimaryColor.withOpacity(0.3)
                      : kPrimaryColor),
            ),
          )),
        ),
      ),
    );
  }
}
