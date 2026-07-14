import '../../../../core/utils/result.dart';
import '../entities/brand.dart';
import '../repositories/brand_repository.dart';

class GetAllBrandsUseCase {
  final BrandRepository repository;
  GetAllBrandsUseCase(this.repository);

  Future<Result<List<Brand>>> call({String? searchQuery}) {
    return repository.getAllBrands(searchQuery: searchQuery);
  }
}
