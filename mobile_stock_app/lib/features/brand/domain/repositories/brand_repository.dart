import '../../../../core/utils/result.dart';
import '../entities/brand.dart';

/// Abstract contract. `data/repositories/brand_repository_impl.dart` implements
/// this against SQLite today; a future `FirebaseBrandRepositoryImpl` or
/// `SupabaseBrandRepositoryImpl` would implement the exact same contract
/// with zero changes required anywhere in domain/ or presentation/.
abstract class BrandRepository {
  Future<Result<List<Brand>>> getAllBrands({String? searchQuery});
  Future<Result<Brand>> getBrandById(String id);
  Future<Result<Brand>> createBrand(Brand brand);
  Future<Result<Brand>> updateBrand(Brand brand);
  Future<Result<void>> deleteBrand(String id);
  Future<Result<bool>> brandNameExists(String name, {String? excludeId});
}
