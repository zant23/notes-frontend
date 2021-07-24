import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/controlllers/notes/notes_controller.dart';
import 'package:notes/models/note.dart';

final selectedNoteProvider =
    StateNotifierProvider<SelectedNoteController, Note?>((ref) {
  return SelectedNoteController(ref.read(notesProvider.notifier));
});

class SelectedNoteController extends StateNotifier<Note?> {
  final NotesController _notesController;

  SelectedNoteController(this._notesController, {Note? note}) : super(note);

  void select(Note note) {
    state = note;
  }

  void unSelect() {
    state = null;
  }

  void updateTitle(String title) => state = state?.copyWith(title: title);
  void updateDescription(String description) {
    state = state?.copyWith(description: description);
  }

  Future<bool> save() async {
    if (state?.id != null) {
      return _notesController.updateNote(state!.id!, state!);
    } else {
      return (await _notesController.addNote(note: state)) != null;
    }
  }
}
