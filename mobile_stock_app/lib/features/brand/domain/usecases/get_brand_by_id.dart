import '../../../../core/utils/result.dart';
import '../entities/brand.dart';
import '../repositories/brand_repository.dart';

class GetBrandByIdUseCase {
  final BrandRepository repository;
  GetBrandByIdUseCase(this.repository);

  Future<Result<Brand>> call(String id) {
    return repository.getBrandById(id);
  }
}
