import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Standard return type for all usecases and repository methods.
/// Left = Failure, Right = success value.
///
/// Usage:
/// ```dart
/// Result<List<Brand>> result = await repository.getAllBrands();
/// result.fold(
///   (failure) => showError(failure.message),
///   (brands) => renderList(brands),
/// );
/// ```
typedef Result<T> = Either<Failure, T>;
