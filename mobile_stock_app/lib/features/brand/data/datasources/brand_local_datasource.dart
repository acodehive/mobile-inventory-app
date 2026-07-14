import 'package:sqflite/sqflite.dart';
import '../../../../core/database/db_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/brand_model.dart';

/// The ONLY place in the app that writes raw SQL for brands.
/// A future `BrandRemoteDataSource` (Firebase/Supabase) would expose the
/// exact same method signatures so `BrandRepositoryImpl` doesn't change.
class BrandLocalDataSource {
  final Database db;
  BrandLocalDataSource(this.db);

  Future<List<BrandModel>> getAllBrands({String? searchQuery}) async {
    try {
      final where = (searchQuery != null && searchQuery.trim().isNotEmpty)
          ? 'WHERE b.${DbConstants.colBrandName} LIKE ?'
          : '';
      final args = (searchQuery != null && searchQuery.trim().isNotEmpty) ? ['%${searchQuery.trim()}%'] : null;

      final result = await db.rawQuery('''
        SELECT b.*, COUNT(p.${DbConstants.colProductId}) as product_count
        FROM ${DbConstants.tableBrands} b
        LEFT JOIN ${DbConstants.tableProducts} p
          ON p.${DbConstants.colProductBrandId} = b.${DbConstants.colBrandId}
          AND p.${DbConstants.colProductIsDeleted} = 0
        $where
        GROUP BY b.${DbConstants.colBrandId}
        ORDER BY b.${DbConstants.colBrandName} ASC
      ''', args);

      return result.map(BrandModel.fromMap).toList();
    } catch (e) {
      throw DatabaseException('Failed to fetch brands: $e');
    }
  }

  Future<BrandModel> getBrandById(String id) async {
    try {
      final result = await db.rawQuery('''
        SELECT b.*, COUNT(p.${DbConstants.colProductId}) as product_count
        FROM ${DbConstants.tableBrands} b
        LEFT JOIN ${DbConstants.tableProducts} p
          ON p.${DbConstants.colProductBrandId} = b.${DbConstants.colBrandId}
          AND p.${DbConstants.colProductIsDeleted} = 0
        WHERE b.${DbConstants.colBrandId} = ?
        GROUP BY b.${DbConstants.colBrandId}
      ''', [id]);

      if (result.isEmpty) throw NotFoundException('Brand with id $id not found');
      return BrandModel.fromMap(result.first);
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw DatabaseException('Failed to fetch brand: $e');
    }
  }

  Future<BrandModel> createBrand(BrandModel brand) async {
    try {
      await db.insert(DbConstants.tableBrands, brand.toMap(), conflictAlgorithm: ConflictAlgorithm.abort);
      return brand;
    } catch (e) {
      throw DatabaseException('Failed to create brand: $e');
    }
  }

  Future<BrandModel> updateBrand(BrandModel brand) async {
    try {
      final count = await db.update(
        DbConstants.tableBrands,
        brand.toMap(),
        where: '${DbConstants.colBrandId} = ?',
        whereArgs: [brand.id],
      );
      if (count == 0) throw NotFoundException('Brand with id ${brand.id} not found');
      return brand;
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw DatabaseException('Failed to update brand: $e');
    }
  }

  Future<void> deleteBrand(String id) async {
    try {
      final count = await db.delete(DbConstants.tableBrands, where: '${DbConstants.colBrandId} = ?', whereArgs: [id]);
      if (count == 0) throw NotFoundException('Brand with id $id not found');
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw DatabaseException('Failed to delete brand: $e');
    }
  }

  Future<bool> brandNameExists(String name, {String? excludeId}) async {
    try {
      final where = excludeId != null
          ? '${DbConstants.colBrandName} = ? COLLATE NOCASE AND ${DbConstants.colBrandId} != ?'
          : '${DbConstants.colBrandName} = ? COLLATE NOCASE';
      final args = excludeId != null ? [name, excludeId] : [name];

      final result = await db.query(DbConstants.tableBrands, where: where, whereArgs: args, limit: 1);
      return result.isNotEmpty;
    } catch (e) {
      throw DatabaseException('Failed to check brand name: $e');
    }
  }
}
