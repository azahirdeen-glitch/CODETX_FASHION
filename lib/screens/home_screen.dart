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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppTopBar(
        title: 'ClosetX',
        leading: IconButton(
          icon: const Icon(Icons.checkroom),
          onPressed: () {},
        ),
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
          // Re-fetching happens automatically via streams, but we can give a small delay
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearch(context),
              const SizedBox(height: AppSpacing.lg),
              _buildBanner(context),
              const SizedBox(height: AppSpacing.xxl),
              _buildCategories(context),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    productProvider.searchQuery.isEmpty ? 'Curated for You' : 'Search Results',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: AppTypography.bold,
                        ),
                  ),
                  if (productProvider.searchQuery.isEmpty)
                    TextButton(
                      onPressed: () {
                        productProvider.setActiveCategory('All');
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(fontWeight: AppTypography.bold),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _buildProductGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearch(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => productProvider.searchProducts(val),
        decoration: InputDecoration(
          hintText: 'Search for outfits, brands...',
          prefixIcon: const Icon(Icons.search, color: AppColors.outline),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    productProvider.searchProducts('');
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        image: const DecorationImage(
          image: CachedNetworkImageProvider(
            'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04',
          ),
          fit: BoxFit.cover,
          opacity: 0.4,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NEW SEASON',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primaryFixed,
                    fontWeight: AppTypography.bold,
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Elevate Your\nSummer Style',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: AppTypography.extrabold,
                    height: 1.1,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () {
                Provider.of<ProductProvider>(context, listen: false).setActiveCategory('Outfits');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceContainerLowest,
                foregroundColor: AppColors.primary,
                minimumSize: const Size(120, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: const Text('Shop Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final categories = [
      ('All', Icons.grid_view_outlined),
      ('Outfits', Icons.checkroom_outlined),
      ('Jewelry', Icons.diamond_outlined),
      ('Shoes', Icons.directions_walk_outlined),
      ('Eyewear', Icons.visibility_outlined),
      ('Bags', Icons.shopping_bag_outlined),
    ];

    final productProvider = Provider.of<ProductProvider>(context);

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.lg),
        itemBuilder: (context, index) {
          final categoryName = categories[index].$1;
          final isSelected = productProvider.activeCategory.toLowerCase() == categoryName.toLowerCase();
          return GestureDetector(
            onTap: () {
              productProvider.setActiveCategory(categoryName);
            },
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    categories[index].$2,
                    color: isSelected ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  categories[index].$1,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: isSelected ? AppTypography.bold : AppTypography.medium,
                      ),
                ),
              ],
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
                'No products found for "${productProvider.searchQuery}"',
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
