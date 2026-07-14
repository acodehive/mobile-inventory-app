import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/brand.dart';
import '../repositories/brand_repository.dart';

class UpdateBrandUseCase {
  final BrandRepository repository;
  UpdateBrandUseCase(this.repository);

  Future<Result<Brand>> call(Brand brand) async {
    final trimmedName = brand.name.trim();
    if (trimmedName.isEmpty) {
      return const Left(ValidationFailure('Brand name cannot be empty'));
    }

    final existsResult = await repository.brandNameExists(trimmedName, excludeId: brand.id);
    final duplicate = existsResult.fold((_) => false, (exists) => exists);
    if (duplicate) {
      return Left(DuplicateFailure('A brand named "$trimmedName" already exists'));
    }

    return repository.updateBrand(brand.copyWith(name: trimmedName, updatedAt: DateTime.now()));
  }
}
