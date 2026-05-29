import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../widgets/components/app_navigation.dart';
import '../widgets/components/app_surfaces.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import 'product_details_screen.dart';
import 'wishlist_screen.dart';

class ProductListingScreen extends StatelessWidget {
  const ProductListingScreen({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppTopBar(
        title: 'Runway Collection',
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            tooltip: 'Wishlist',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // List Header Banner
              _buildHeroBanner(context),
              const SizedBox(height: AppSpacing.xxl),
              // Filters
              _buildFilters(context),
              const SizedBox(height: AppSpacing.xl),
              // Listing Grid
              _buildProductGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        image: const DecorationImage(
          image: CachedNetworkImageProvider(
            'https://images.unsplash.com/photo-1490481651871-ab68de25d43d',
          ),
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
        color: AppColors.primary,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Summer Collection \'24',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: AppTypography.extrabold,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: AppColors.onPrimary.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                'UP TO 50% OFF',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: AppTypography.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    final filters = [
      ('All', 'All Items'),
      ('Outfits', 'Outfits'),
      ('Jewelry', 'Jewelry'),
      ('Shoes', 'Shoes'),
      ('Eyewear', 'Eyewear'),
      ('Bags', 'Bags'),
    ];

    final productProvider = Provider.of<ProductProvider>(context);

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final categoryKey = filters[index].$1;
          final isSelected = productProvider.activeCategory.toLowerCase() == categoryKey.toLowerCase();
          return GestureDetector(
            onTap: () {
              productProvider.setActiveCategory(categoryKey);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: isSelected ? null : Border.all(color: AppColors.outlineVariant),
              ),
              alignment: Alignment.center,
              child: Text(
                filters[index].$2,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                      fontWeight: isSelected ? AppTypography.bold : AppTypography.medium,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final filtered = productProvider.filteredProducts;

    if (productProvider.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            children: [
              const Icon(Icons.search_off, size: 48, color: AppColors.outline),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No products found in "${productProvider.activeCategory}"',
                style: const TextStyle(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (productProvider.allProducts.isEmpty) ...[
                const Text(
                  'The database is currently empty.',
                  style: TextStyle(fontSize: 13, color: AppColors.outline, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.7,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final product = filtered[index];
        return Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsScreen(product: product),
                  ),
                );
              },
              child: AppGridItem(
                title: product.title,
                price: product.formattedDiscountedPrice,
                isFavorite: auth.isProductInWishlist(product.id),
                onFavoriteTap: () {
                  auth.toggleWishlist(product.id);
                },
                image: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
