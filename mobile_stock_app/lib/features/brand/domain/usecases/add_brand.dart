import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/brand.dart';
import '../repositories/brand_repository.dart';

class AddBrandUseCase {
  final BrandRepository repository;
  final Uuid uuid;
  AddBrandUseCase(this.repository, this.uuid);

  Future<Result<Brand>> call({
    required String name,
    String? logoPath,
    int? colorValue,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return const Left(ValidationFailure('Brand name cannot be empty'));
    }

    final existsResult = await repository.brandNameExists(trimmedName);
    final duplicate = existsResult.fold((_) => false, (exists) => exists);
    if (duplicate) {
      return Left(DuplicateFailure('A brand named "$trimmedName" already exists'));
    }

    final now = DateTime.now();
    final brand = Brand(
      id: uuid.v4(),
      name: trimmedName,
      logoPath: logoPath,
      colorValue: colorValue,
      createdAt: now,
      updatedAt: now,
    );

    return repository.createBrand(brand);
  }
}
