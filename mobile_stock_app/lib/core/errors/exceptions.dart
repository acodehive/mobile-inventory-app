/// Thrown by datasources when something goes wrong at the data-access level.
class DatabaseException implements Exception {
  final String message;
  DatabaseException([this.message = 'A database error occurred']);
  @override
  String toString() => 'DatabaseException: $message';
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException([this.message = 'Requested item was not found']);
  @override
  String toString() => 'NotFoundException: $message';
}

class DuplicateException implements Exception {
  final String message;
  DuplicateException([this.message = 'This item already exists']);
  @override
  String toString() => 'DuplicateException: $message';
}

class ValidationException implements Exception {
  final String message;
  ValidationException([this.message = 'Invalid input']);
  @override
  String toString() => 'ValidationException: $message';
}
