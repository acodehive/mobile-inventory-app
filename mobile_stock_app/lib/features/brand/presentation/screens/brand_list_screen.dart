import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../providers/brand_providers.dart';
import 'add_edit_brand_screen.dart';
import '../widgets/brand_card.dart';

class BrandListScreen extends ConsumerWidget {
  const BrandListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandsAsync = ref.watch(brandListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navBrands),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditBrandScreen()),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text(AppStrings.addBrand),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSearchBar(
                hintText: 'Search brands...',
                onChanged: (value) => ref.read(brandSearchQueryProvider.notifier).state = value,
              ),
              const SizedBox(height: AppDimens.md),
              Expanded(
                child: brandsAsync.when(
                  loading: () => GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppDimens.gridSpacing,
                      crossAxisSpacing: AppDimens.gridSpacing,
                      childAspectRatio: 1.15,
                    ),
                    itemCount: 6,
                    itemBuilder: (_, __) => const SkeletonWrap(
                      isLoading: true,
                      skeleton: StatCardSkeleton(),
                      child: SizedBox.shrink(),
                    ),
                  ),
                  error: (error, _) => EmptyState(
                    icon: Icons.error_outline_rounded,
                    title: AppStrings.somethingWentWrong,
                    subtitle: error.toString(),
                    actionLabel: AppStrings.retry,
                    onAction: () => ref.read(brandListProvider.notifier).refresh(),
                  ),
                  data: (brands) {
                    if (brands.isEmpty) {
                      return const EmptyState(
                        icon: Icons.storefront_outlined,
                        title: AppStrings.noBrandsFound,
                        subtitle: 'Tap "Add Brand" to create your first one.',
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () => ref.read(brandListProvider.notifier).refresh(),
                      child: GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppDimens.gridSpacing,
                          crossAxisSpacing: AppDimens.gridSpacing,
                          childAspectRatio: 1.15,
                        ),
                        itemCount: brands.length,
                        itemBuilder: (context, index) {
                          final brand = brands[index];
                          return BrandCard(
                            brand: brand,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => AddEditBrandScreen(brand: brand)),
                            ),
                            onEdit: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => AddEditBrandScreen(brand: brand)),
                            ),
                            onDelete: () async {
                              final confirmed = await showConfirmDialog(
                                context,
                                title: 'Delete ${brand.name}?',
                                message: brand.productCount > 0
                                    ? '${brand.productCount} product(s) will keep their data but lose this brand link.'
                                    : 'This action cannot be undone.',
                              );
                              if (confirmed && context.mounted) {
                                final error = await ref.read(brandListProvider.notifier).deleteBrand(brand.id);
                                if (error != null && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                                }
                              }
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
