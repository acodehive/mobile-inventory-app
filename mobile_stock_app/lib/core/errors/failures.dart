import 'package:equatable/equatable.dart';

/// Domain-layer error representation. Repositories translate low-level
/// [Exception]s from the data layer into one of these before returning
/// to usecases, so the presentation layer never has to know about
/// SQLite/Firebase/etc. specifics.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'A database error occurred']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Item not found']);
}

class DuplicateFailure extends Failure {
  const DuplicateFailure([super.message = 'Item already exists']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Invalid input']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Something went wrong']);
}
