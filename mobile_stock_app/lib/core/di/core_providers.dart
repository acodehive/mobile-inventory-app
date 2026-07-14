import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

/// Exposes the raw [Database] instance. Feature datasources depend on this
/// rather than on [AppDatabase] directly, keeping a single seam for tests
/// (override this provider with an in-memory sqflite_common_ffi database).
final databaseProvider = FutureProvider<Database>((ref) async {
  return AppDatabase.instance.database;
});

/// Shared UUID generator for creating entity IDs across all features.
final uuidProvider = Provider<Uuid>((ref) => const Uuid());
