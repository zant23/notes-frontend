import 'package:dartz/dartz.dart';
import 'package:notes/models/note.dart';
import 'package:notes/repositories/core/failures.dart';

abstract class BaseNotesRepository {
  Future<Either<RepositoryFailure, List<Note>>> getNotes();
  Future<Either<RepositoryFailure, Note>> getNote(String id);
  Future<Either<RepositoryFailure, Note>> updateNote(String id, Note note);
  Future<Either<RepositoryFailure, Note>> deleteNote(String id);
  Future<Either<RepositoryFailure, Note>> createNote(Note note);
}
