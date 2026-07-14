import '../../../../core/database/db_constants.dart';
import '../../domain/entities/brand.dart';

/// Data-layer representation of [Brand]. Knows how to (de)serialize
/// to/from a SQLite row. When migrating to Firebase/Supabase, you'd add a
/// sibling `BrandModel.fromJson`/`toJson` here — domain/entities/brand.dart
/// never needs to change.
class BrandModel extends Brand {
  const BrandModel({
    required super.id,
    required super.name,
    super.logoPath,
    super.colorValue,
    required super.createdAt,
    required super.updatedAt,
    super.productCount = 0,
  });

  factory BrandModel.fromMap(Map<String, Object?> map) {
    return BrandModel(
      id: map[DbConstants.colBrandId] as String,
      name: map[DbConstants.colBrandName] as String,
      logoPath: map[DbConstants.colBrandLogoPath] as String?,
      colorValue: map[DbConstants.colBrandColor] != null
          ? int.tryParse(map[DbConstants.colBrandColor] as String)
          : null,
      createdAt: DateTime.parse(map[DbConstants.colBrandCreatedAt] as String),
      updatedAt: DateTime.parse(map[DbConstants.colBrandUpdatedAt] as String),
      productCount: (map['product_count'] as int?) ?? 0,
    );
  }

  Map<String, Object?> toMap() {
    return {
      DbConstants.colBrandId: id,
      DbConstants.colBrandName: name,
      DbConstants.colBrandLogoPath: logoPath,
      DbConstants.colBrandColor: colorValue?.toString(),
      DbConstants.colBrandCreatedAt: createdAt.toIso8601String(),
      DbConstants.colBrandUpdatedAt: updatedAt.toIso8601String(),
    };
  }

  factory BrandModel.fromEntity(Brand brand) {
    return BrandModel(
      id: brand.id,
      name: brand.name,
      logoPath: brand.logoPath,
      colorValue: brand.colorValue,
      createdAt: brand.createdAt,
      updatedAt: brand.updatedAt,
      productCount: brand.productCount,
    );
  }
}
