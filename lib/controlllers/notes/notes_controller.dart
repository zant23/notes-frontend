import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/models/note.dart';
import 'package:notes/repositories/core/failures.dart';
import 'package:notes/repositories/notes/base_notes_repository.dart';
import 'package:notes/repositories/notes/notes_repository.dart';

final notesProvider =
    StateNotifierProvider<NotesController, AsyncValue<List<Note>>>((ref) {
  final NotesRepository notesRepository = ref.read(notesRepositoryProvider);
  return NotesController(notesRepository);
});

class NotesController extends StateNotifier<AsyncValue<List<Note>>> {
  final BaseNotesRepository _baseNotesRepository;

  NotesController(this._baseNotesRepository)
      : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    final Either<RepositoryFailure, List<Note>> failureOrNotes =
        await _baseNotesRepository.getNotes();
    failureOrNotes.fold((failure) {
      state = AsyncValue.error(failure);
    }, (notes) {
      state = AsyncValue.data(notes);
    });
  }

  Future<Note?> addNote({Note? note}) async {
    final Either<RepositoryFailure, Note> failureOrNote =
        await _baseNotesRepository
            .createNote(note ?? Note(title: '', description: ''));
    return failureOrNote.fold((failure) {}, (newNote) {
      _addNoteToState(newNote);
      return newNote;
    });
  }

  Future<bool> deleteNote(String id) async {
    final Either<RepositoryFailure, Note> failureOrNote =
        await _baseNotesRepository.deleteNote(id);
    return failureOrNote.fold((failure) => false, (deletedNote) {
      _deleteNoteFromState(deletedNote);
      return true;
    });
  }

  Future<bool> updateNote(String id, Note note) async {
    final Either<RepositoryFailure, Note> failureOrNote =
        await _baseNotesRepository.updateNote(id, note);

    return failureOrNote.fold((_) => false, (updatedNote) {
      _updateNoteInState(id, updatedNote);
      return true;
    });
  }

  void _addNoteToState(Note note) {
    state.whenData((notes) {
      state = AsyncValue.data([...notes, note]);
    });
  }

  void _deleteNoteFromState(Note deletedNote) {
    state.whenData((notes) {
      state = AsyncValue.data(
          notes.where((note) => deletedNote.id != note.id).toList());
    });
  }

  void _updateNoteInState(String id, Note note) {
    state.whenData((notes) {
      final index = notes.indexWhere((oldNote) => oldNote.id == id);
      if (!index.isNegative) {
        state = AsyncValue.data(notes
          ..removeAt(index)
          ..insert(index, note));
      }
    });
  }
}
