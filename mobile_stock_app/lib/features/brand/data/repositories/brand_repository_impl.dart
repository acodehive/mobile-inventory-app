import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/brand.dart';
import '../../domain/repositories/brand_repository.dart';
import '../datasources/brand_local_datasource.dart';
import '../models/brand_model.dart';

/// Implements the abstract [BrandRepository] against SQLite via
/// [BrandLocalDataSource]. This is the ONLY class that knows both
/// "domain language" (Brand, Failure) and "data language" (exceptions,
/// raw maps). Swap this file's internals (and the datasource it wraps)
/// to migrate backends — nothing above this layer changes.
class BrandRepositoryImpl implements BrandRepository {
  final BrandLocalDataSource localDataSource;
  BrandRepositoryImpl(this.localDataSource);

  @override
  Future<Result<List<Brand>>> getAllBrands({String? searchQuery}) async {
    try {
      final brands = await localDataSource.getAllBrands(searchQuery: searchQuery);
      return Right(brands);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<Brand>> getBrandById(String id) async {
    try {
      final brand = await localDataSource.getBrandById(id);
      return Right(brand);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<Brand>> createBrand(Brand brand) async {
    try {
      final created = await localDataSource.createBrand(BrandModel.fromEntity(brand));
      return Right(created);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<Brand>> updateBrand(Brand brand) async {
    try {
      final updated = await localDataSource.updateBrand(BrandModel.fromEntity(brand));
      return Right(updated);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteBrand(String id) async {
    try {
      await localDataSource.deleteBrand(id);
      return const Right(null);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> brandNameExists(String name, {String? excludeId}) async {
    try {
      final exists = await localDataSource.brandNameExists(name, excludeId: excludeId);
      return Right(exists);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
