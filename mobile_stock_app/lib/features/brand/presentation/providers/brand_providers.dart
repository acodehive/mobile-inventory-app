import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/core_providers.dart';
import '../../data/datasources/brand_local_datasource.dart';
import '../../data/repositories/brand_repository_impl.dart';
import '../../domain/entities/brand.dart';
import '../../domain/repositories/brand_repository.dart';
import '../../domain/usecases/add_brand.dart';
import '../../domain/usecases/delete_brand.dart';
import '../../domain/usecases/get_all_brands.dart';
import '../../domain/usecases/get_brand_by_id.dart';
import '../../domain/usecases/update_brand.dart';

// ---------------------------------------------------------------------------
// Wiring: datasource -> repository -> usecases
// NOTE: `databaseProvider` is pre-warmed and overridden with a resolved
// AsyncData(db) in main.dart before runApp(), so `.requireValue` below is
// safe to call synchronously anywhere in the widget tree.
// ---------------------------------------------------------------------------

final brandLocalDataSourceProvider = Provider<BrandLocalDataSource>((ref) {
  final db = ref.watch(databaseProvider).requireValue;
  return BrandLocalDataSource(db);
});

final brandRepositoryProvider = Provider<BrandRepository>((ref) {
  return BrandRepositoryImpl(ref.watch(brandLocalDataSourceProvider));
});

final getAllBrandsUseCaseProvider = Provider((ref) => GetAllBrandsUseCase(ref.watch(brandRepositoryProvider)));
final addBrandUseCaseProvider = Provider((ref) => AddBrandUseCase(ref.watch(brandRepositoryProvider), ref.watch(uuidProvider)));
final updateBrandUseCaseProvider = Provider((ref) => UpdateBrandUseCase(ref.watch(brandRepositoryProvider)));
final deleteBrandUseCaseProvider = Provider((ref) => DeleteBrandUseCase(ref.watch(brandRepositoryProvider)));
final getBrandByIdUseCaseProvider = Provider((ref) => GetBrandByIdUseCase(ref.watch(brandRepositoryProvider)));

// ---------------------------------------------------------------------------
// UI-facing state
// ---------------------------------------------------------------------------

/// Current search query typed into the Brands screen search bar.
final brandSearchQueryProvider = StateProvider<String>((ref) => '');

/// Holds the list of brands, re-fetched whenever the search query changes
/// or a mutation (add/update/delete) succeeds.
class BrandListNotifier extends AsyncNotifier<List<Brand>> {
  @override
  Future<List<Brand>> build() async {
    final query = ref.watch(brandSearchQueryProvider);
    final result = await ref.watch(getAllBrandsUseCaseProvider).call(searchQuery: query.isEmpty ? null : query);
    return result.fold((failure) => throw failure, (brands) => brands);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<String?> addBrand({required String name, String? logoPath, int? colorValue}) async {
    final result = await ref.read(addBrandUseCaseProvider).call(name: name, logoPath: logoPath, colorValue: colorValue);
    return result.fold(
      (failure) => failure.message,
      (_) {
        refresh();
        return null;
      },
    );
  }

  Future<String?> updateBrand(Brand brand) async {
    final result = await ref.read(updateBrandUseCaseProvider).call(brand);
    return result.fold(
      (failure) => failure.message,
      (_) {
        refresh();
        return null;
      },
    );
  }

  Future<String?> deleteBrand(String brandId) async {
    final result = await ref.read(deleteBrandUseCaseProvider).call(brandId);
    return result.fold(
      (failure) => failure.message,
      (_) {
        refresh();
        return null;
      },
    );
  }
}

final brandListProvider = AsyncNotifierProvider<BrandListNotifier, List<Brand>>(BrandListNotifier.new);

/// Total brand count — used by the Dashboard feature.
final brandCountProvider = Provider<int>((ref) {
  return ref.watch(brandListProvider).maybeWhen(data: (brands) => brands.length, orElse: () => 0);
});
