import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Wraps [child] with a shimmering skeleton effect while [isLoading] is true.
class SkeletonWrap extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Widget skeleton;

  const SkeletonWrap({super.key, required this.isLoading, required this.child, required this.skeleton});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
      highlightColor: isDark ? AppColors.darkBorder : AppColors.pureWhite,
      child: skeleton,
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const SkeletonBox({super.key, this.width = double.infinity, this.height = 16, this.radius = AppDimens.radiusSm});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(radius)),
    );
  }
}

/// Skeleton for a single product list tile.
class ProductTileSkeleton extends StatelessWidget {
  const ProductTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.sm, horizontal: AppDimens.md),
      child: Row(
        children: [
          const SkeletonBox(width: AppDimens.productThumbSize, height: AppDimens.productThumbSize, radius: AppDimens.radiusMd),
          const SizedBox(width: AppDimens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonBox(width: 160, height: 14),
                SizedBox(height: 8),
                SkeletonBox(width: 100, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton grid for the dashboard stat cards.
class StatCardSkeleton extends StatelessWidget {
  const StatCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.statCardHeight,
      padding: const EdgeInsets.all(AppDimens.md),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimens.radiusLg)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          SkeletonBox(width: 40, height: 40, radius: AppDimens.radiusSm),
          SkeletonBox(width: 60, height: 20),
        ],
      ),
    );
  }
}
