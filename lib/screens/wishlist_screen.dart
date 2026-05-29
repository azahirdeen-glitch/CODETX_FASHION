import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/components/app_surfaces.dart';
import 'product_details_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final wishlistIds = authProvider.userModel?.wishlist ?? [];
    final wishlistProducts = productProvider.allProducts
        .where((product) => wishlistIds.contains(product.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(fontWeight: AppTypography.bold),
        ),
        centerTitle: true,
      ),
      body: wishlistProducts.isEmpty
          ? _buildEmptyState(context)
          : GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.7,
              ),
              itemCount: wishlistProducts.length,
              itemBuilder: (context, index) {
                final product = wishlistProducts[index];
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
                    isFavorite: true,
                    onFavoriteTap: () {
                      authProvider.toggleWishlist(product.id);
                    },
                    image: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: AppColors.outline.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Your wishlist is empty',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Save items you love to find them later',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.outline),
          ),
        ],
      ),
    );
  }
}
