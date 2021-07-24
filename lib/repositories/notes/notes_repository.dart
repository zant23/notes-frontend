import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:notes/models/note.dart';
import 'package:notes/repositories/core/failures.dart';
import 'package:notes/repositories/notes/base_notes_repository.dart';

final notesRepositoryProvider =
    Provider<NotesRepository>((ref) => NotesRepository());

class NotesRepository implements BaseNotesRepository {
  static const String apiUrl = 'https://notes-dario.herokuapp.com/api';

  @override
  Future<Either<RepositoryFailure, Note>> deleteNote(String id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/notes/$id'));
      if (response.statusCode == 200) {
        return right(
            Note.fromJson(jsonDecode(response.body) as Map<String, dynamic>));
      }
      return left(_statusCodeToRepositoryFailure(response.statusCode));
    } catch (_) {
      return left(RepositoryFailure.internalFailure());
    }
  }

  @override
  Future<Either<RepositoryFailure, Note>> getNote(String id) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/notes/$id'));
      if (response.statusCode == 200) {
        return right(
            Note.fromJson(jsonDecode(response.body) as Map<String, dynamic>));
      }
      return left(_statusCodeToRepositoryFailure(response.statusCode));
    } catch (_) {
      return left(RepositoryFailure.internalFailure());
    }
  }

  @override
  Future<Either<RepositoryFailure, List<Note>>> getNotes() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/notes'));
      if (response.statusCode == 200) {
        return right(Note.fromJsonList(jsonDecode(response.body) as List));
      }
      return left(_statusCodeToRepositoryFailure(response.statusCode));
    } catch (e) {
      return left(RepositoryFailure.internalFailure());
    }
  }

  @override
  Future<Either<RepositoryFailure, Note>> updateNote(
      String id, Note note) async {
    try {
      final Map<String, dynamic> body = note.toJson()..remove('id');
      final response =
          await http.patch(Uri.parse('$apiUrl/notes/$id'), body: body);
      if (response.statusCode == 200) {
        return right(
            Note.fromJson(jsonDecode(response.body) as Map<String, dynamic>));
      }
      return left(_statusCodeToRepositoryFailure(response.statusCode));
    } on Exception catch (_) {
      return left(RepositoryFailure.internalFailure());
    }
  }

  @override
  Future<Either<RepositoryFailure, Note>> createNote(Note note) async {
    try {
      final Map<String, dynamic> body = note.toJson()..remove('id');
      final response = await http.post(Uri.parse('$apiUrl/notes'), body: body);
      if (response.statusCode == 201) {
        return right(
            Note.fromJson(jsonDecode(response.body) as Map<String, dynamic>));
      }
      return left(_statusCodeToRepositoryFailure(response.statusCode));
    } on Exception catch (_) {
      return left(RepositoryFailure.internalFailure());
    }
  }

  RepositoryFailure _statusCodeToRepositoryFailure(int statusCode) {
    switch (statusCode) {
      case 400:
        return RepositoryFailure.notValid();
      case 401:
        return RepositoryFailure.unAuthorized();
      case 404:
        return RepositoryFailure.notFound();
      case 500:
      default:
        return RepositoryFailure.internalFailure();
    }
  }
}
