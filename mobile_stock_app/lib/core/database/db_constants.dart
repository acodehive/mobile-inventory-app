/// Table & column name constants.
/// Keeping these centralized means the repository layer never hardcodes
/// strings, which makes a future migration to Postgres/Firebase/Supabase
/// a matter of swapping the datasource implementation, not rewriting queries.
class DbConstants {
  DbConstants._();

  static const dbName = 'stock_manager.db';
  static const dbVersion = 1;

  // ---- Brands table ----
  static const tableBrands = 'brands';
  static const colBrandId = 'id';
  static const colBrandName = 'name';
  static const colBrandLogoPath = 'logo_path';
  static const colBrandColor = 'color_hex';
  static const colBrandCreatedAt = 'created_at';
  static const colBrandUpdatedAt = 'updated_at';

  // ---- Categories table (mobile / accessory / custom accessory types) ----
  static const tableCategories = 'categories';
  static const colCategoryId = 'id';
  static const colCategoryName = 'name';
  static const colCategoryType = 'type'; // 'mobile' | 'accessory'
  static const colCategoryIsCustom = 'is_custom';
  static const colCategoryIcon = 'icon_name';

  // ---- Products table (unified for mobile + accessory, discriminated by `type`) ----
  static const tableProducts = 'products';
  static const colProductId = 'id';
  static const colProductType = 'type'; // 'mobile' | 'accessory'
  static const colProductBrandId = 'brand_id';
  static const colProductCategoryId = 'category_id';
  static const colProductName = 'name'; // model name (mobile) or accessory name
  static const colProductVariant = 'variant';
  static const colProductRam = 'ram';
  static const colProductStorage = 'storage';
  static const colProductColor = 'color';
  static const colProductImei = 'imei';
  static const colProductSerialNumber = 'serial_number';
  static const colProductPurchasePrice = 'purchase_price';
  static const colProductSellingPrice = 'selling_price';
  static const colProductSupplier = 'supplier';
  static const colProductQuantity = 'quantity';
  static const colProductLowStockThreshold = 'low_stock_threshold';
  static const colProductBarcode = 'barcode';
  static const colProductDateAdded = 'date_added';
  static const colProductWarrantyMonths = 'warranty_months';
  static const colProductStatus = 'status'; // active | discontinued | sold
  static const colProductNotes = 'notes';
  static const colProductDescription = 'description';
  static const colProductImagePath = 'image_path';
  static const colProductUpdatedAt = 'updated_at';
  static const colProductIsDeleted = 'is_deleted'; // soft delete for sync-safety

  // ---- Stock movements table (audit trail for every quantity change) ----
  static const tableStockMovements = 'stock_movements';
  static const colMovementId = 'id';
  static const colMovementProductId = 'product_id';
  static const colMovementType = 'type'; // increase | decrease | adjustment
  static const colMovementQuantity = 'quantity';
  static const colMovementReason = 'reason';
  static const colMovementCreatedAt = 'created_at';

  // ---- Shop settings table (single row) ----
  static const tableShopSettings = 'shop_settings';
  static const colSettingsId = 'id';
  static const colSettingsBusinessName = 'business_name';
  static const colSettingsGstNumber = 'gst_number';
  static const colSettingsAddress = 'address';
  static const colSettingsPhone = 'phone';
  static const colSettingsCurrency = 'currency';
  static const colSettingsThemeMode = 'theme_mode';
}
