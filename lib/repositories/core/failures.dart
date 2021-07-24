import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class RepositoryFailure with _$RepositoryFailure {
  factory RepositoryFailure.unAuthorized() = Unauthorized;
  factory RepositoryFailure.notFound() = NotFound;
  factory RepositoryFailure.internalFailure() = InternalFailure;
  factory RepositoryFailure.notValid() = NotValid;
}
