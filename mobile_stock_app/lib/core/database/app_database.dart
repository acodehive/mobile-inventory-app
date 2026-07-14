import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'db_constants.dart';

/// Singleton wrapper around the local SQLite database.
///
/// IMPORTANT (future cloud migration note):
/// All feature repositories talk to this class only through the
/// `AppDatabase.instance.database` getter and raw query helpers below.
/// When migrating to MySQL/PostgreSQL/Firebase/Supabase, only the
/// `datasources/*_local_datasource.dart` files need a remote counterpart
/// implementing the same abstract repository interface — no business logic
/// (usecases, providers, UI) will need to change.
class AppDatabase {
  AppDatabase._internal();
  static final AppDatabase instance = AppDatabase._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DbConstants.dbName);

    return openDatabase(
      path,
      version: DbConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    // ---- Brands ----
    batch.execute('''
      CREATE TABLE ${DbConstants.tableBrands} (
        ${DbConstants.colBrandId} TEXT PRIMARY KEY,
        ${DbConstants.colBrandName} TEXT NOT NULL UNIQUE,
        ${DbConstants.colBrandLogoPath} TEXT,
        ${DbConstants.colBrandColor} TEXT,
        ${DbConstants.colBrandCreatedAt} TEXT NOT NULL,
        ${DbConstants.colBrandUpdatedAt} TEXT NOT NULL
      )
    ''');

    // ---- Categories ----
    batch.execute('''
      CREATE TABLE ${DbConstants.tableCategories} (
        ${DbConstants.colCategoryId} TEXT PRIMARY KEY,
        ${DbConstants.colCategoryName} TEXT NOT NULL,
        ${DbConstants.colCategoryType} TEXT NOT NULL,
        ${DbConstants.colCategoryIsCustom} INTEGER NOT NULL DEFAULT 0,
        ${DbConstants.colCategoryIcon} TEXT
      )
    ''');

    // ---- Products (unified mobile + accessory) ----
    batch.execute('''
      CREATE TABLE ${DbConstants.tableProducts} (
        ${DbConstants.colProductId} TEXT PRIMARY KEY,
        ${DbConstants.colProductType} TEXT NOT NULL,
        ${DbConstants.colProductBrandId} TEXT,
        ${DbConstants.colProductCategoryId} TEXT,
        ${DbConstants.colProductName} TEXT NOT NULL,
        ${DbConstants.colProductVariant} TEXT,
        ${DbConstants.colProductRam} TEXT,
        ${DbConstants.colProductStorage} TEXT,
        ${DbConstants.colProductColor} TEXT,
        ${DbConstants.colProductImei} TEXT,
        ${DbConstants.colProductSerialNumber} TEXT,
        ${DbConstants.colProductPurchasePrice} REAL NOT NULL DEFAULT 0,
        ${DbConstants.colProductSellingPrice} REAL NOT NULL DEFAULT 0,
        ${DbConstants.colProductSupplier} TEXT,
        ${DbConstants.colProductQuantity} INTEGER NOT NULL DEFAULT 0,
        ${DbConstants.colProductLowStockThreshold} INTEGER NOT NULL DEFAULT 3,
        ${DbConstants.colProductBarcode} TEXT,
        ${DbConstants.colProductDateAdded} TEXT NOT NULL,
        ${DbConstants.colProductWarrantyMonths} INTEGER,
        ${DbConstants.colProductStatus} TEXT NOT NULL DEFAULT 'active',
        ${DbConstants.colProductNotes} TEXT,
        ${DbConstants.colProductDescription} TEXT,
        ${DbConstants.colProductImagePath} TEXT,
        ${DbConstants.colProductUpdatedAt} TEXT NOT NULL,
        ${DbConstants.colProductIsDeleted} INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (${DbConstants.colProductBrandId}) REFERENCES ${DbConstants.tableBrands} (${DbConstants.colBrandId}) ON DELETE SET NULL,
        FOREIGN KEY (${DbConstants.colProductCategoryId}) REFERENCES ${DbConstants.tableCategories} (${DbConstants.colCategoryId}) ON DELETE SET NULL
      )
    ''');

    batch.execute('CREATE INDEX idx_products_type ON ${DbConstants.tableProducts} (${DbConstants.colProductType})');
    batch.execute('CREATE INDEX idx_products_brand ON ${DbConstants.tableProducts} (${DbConstants.colProductBrandId})');
    batch.execute('CREATE INDEX idx_products_barcode ON ${DbConstants.tableProducts} (${DbConstants.colProductBarcode})');

    // ---- Stock movement audit trail ----
    batch.execute('''
      CREATE TABLE ${DbConstants.tableStockMovements} (
        ${DbConstants.colMovementId} TEXT PRIMARY KEY,
        ${DbConstants.colMovementProductId} TEXT NOT NULL,
        ${DbConstants.colMovementType} TEXT NOT NULL,
        ${DbConstants.colMovementQuantity} INTEGER NOT NULL,
        ${DbConstants.colMovementReason} TEXT,
        ${DbConstants.colMovementCreatedAt} TEXT NOT NULL,
        FOREIGN KEY (${DbConstants.colMovementProductId}) REFERENCES ${DbConstants.tableProducts} (${DbConstants.colProductId}) ON DELETE CASCADE
      )
    ''');

    // ---- Shop settings (single row) ----
    batch.execute('''
      CREATE TABLE ${DbConstants.tableShopSettings} (
        ${DbConstants.colSettingsId} INTEGER PRIMARY KEY CHECK (${DbConstants.colSettingsId} = 1),
        ${DbConstants.colSettingsBusinessName} TEXT,
        ${DbConstants.colSettingsGstNumber} TEXT,
        ${DbConstants.colSettingsAddress} TEXT,
        ${DbConstants.colSettingsPhone} TEXT,
        ${DbConstants.colSettingsCurrency} TEXT NOT NULL DEFAULT 'INR',
        ${DbConstants.colSettingsThemeMode} TEXT NOT NULL DEFAULT 'system'
      )
    ''');

    await batch.commit(noResult: true);
    await _seedDefaultData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Future schema migrations go here, e.g.:
    // if (oldVersion < 2) { await db.execute('ALTER TABLE ... '); }
  }

  Future<void> _seedDefaultData(Database db) async {
    final now = DateTime.now().toIso8601String();

    // Default categories
    const mobileCategories = ['Mobile Phones'];
    const accessoryCategories = [
      'Charger', 'Cable', 'Earphones', 'Bluetooth Earbuds', 'Neckband',
      'Power Bank', 'Screen Protector', 'Back Cover', 'Camera Lens Protector',
      'Smart Watch', 'Adapter', 'OTG', 'Memory Card', 'Mobile Stand', 'Car Charger',
    ];

    final batch = db.batch();
    for (final name in mobileCategories) {
      batch.insert(DbConstants.tableCategories, {
        DbConstants.colCategoryId: 'cat_${name.toLowerCase().replaceAll(' ', '_')}',
        DbConstants.colCategoryName: name,
        DbConstants.colCategoryType: 'mobile',
        DbConstants.colCategoryIsCustom: 0,
      });
    }
    for (final name in accessoryCategories) {
      batch.insert(DbConstants.tableCategories, {
        DbConstants.colCategoryId: 'cat_${name.toLowerCase().replaceAll(' ', '_')}',
        DbConstants.colCategoryName: name,
        DbConstants.colCategoryType: 'accessory',
        DbConstants.colCategoryIsCustom: 0,
      });
    }

    // Default shop settings row
    batch.insert(DbConstants.tableShopSettings, {
      DbConstants.colSettingsId: 1,
      DbConstants.colSettingsCurrency: 'INR',
      DbConstants.colSettingsThemeMode: 'system',
    });

    await batch.commit(noResult: true);

    // Default brands
    const defaultBrands = [
      'Apple', 'Samsung', 'Vivo', 'Oppo', 'Xiaomi', 'Motorola',
      'Realme', 'OnePlus', 'Google Pixel', 'Nothing', 'Nokia', 'Honor',
    ];
    final brandBatch = db.batch();
    for (final name in defaultBrands) {
      brandBatch.insert(DbConstants.tableBrands, {
        DbConstants.colBrandId: 'brand_${name.toLowerCase().replaceAll(' ', '_')}',
        DbConstants.colBrandName: name,
        DbConstants.colBrandCreatedAt: now,
        DbConstants.colBrandUpdatedAt: now,
      });
    }
    await brandBatch.commit(noResult: true);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
