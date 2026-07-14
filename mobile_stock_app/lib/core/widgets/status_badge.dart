import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

enum StockStatus { inStock, lowStock, outOfStock }

class StatusBadge extends StatelessWidget {
  final StockStatus status;
  final String? customLabel;

  const StatusBadge({super.key, required this.status, this.customLabel});

  ({Color color, String label}) get _config {
    switch (status) {
      case StockStatus.inStock:
        return (color: AppColors.inStock, label: customLabel ?? 'In Stock');
      case StockStatus.lowStock:
        return (color: AppColors.lowStock, label: customLabel ?? 'Low Stock');
      case StockStatus.outOfStock:
        return (color: AppColors.outOfStock, label: customLabel ?? 'Out of Stock');
    }
  }

  static StockStatus fromQuantity(int quantity, int threshold) {
    if (quantity <= 0) return StockStatus.outOfStock;
    if (quantity <= threshold) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  @override
  Widget build(BuildContext context) {
    final config = _config;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.sm, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: config.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            config.label,
            style: TextStyle(color: config.color, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
