import '../../../../core/utils/result.dart';
import '../repositories/brand_repository.dart';

class DeleteBrandUseCase {
  final BrandRepository repository;
  DeleteBrandUseCase(this.repository);

  Future<Result<void>> call(String brandId) {
    return repository.deleteBrand(brandId);
  }
}
