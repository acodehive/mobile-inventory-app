import 'package:equatable/equatable.dart';

/// Pure domain entity — no SQLite, no JSON, no Flutter imports.
/// This is what usecases and UI work with.
class Brand extends Equatable {
  final String id;
  final String name;
  final String? logoPath;
  final int? colorValue; // ARGB int, nullable = use default palette color
  final DateTime createdAt;
  final DateTime updatedAt;
  final int productCount; // populated by joined queries, not persisted on the row itself

  const Brand({
    required this.id,
    required this.name,
    this.logoPath,
    this.colorValue,
    required this.createdAt,
    required this.updatedAt,
    this.productCount = 0,
  });

  Brand copyWith({
    String? id,
    String? name,
    String? logoPath,
    int? colorValue,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? productCount,
  }) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      logoPath: logoPath ?? this.logoPath,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      productCount: productCount ?? this.productCount,
    );
  }

  @override
  List<Object?> get props => [id, name, logoPath, colorValue, createdAt, updatedAt, productCount];
}
