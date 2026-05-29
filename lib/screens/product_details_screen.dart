import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/product_model.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/components/app_buttons.dart';
import 'cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late String _selectedSize;

  @override
  void initState() {
    super.initState();
    // Default to first size in list, or 'M' if empty
    _selectedSize = widget.product.sizes.isNotEmpty ? widget.product.sizes[0] : 'M';
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Header
                _buildImageStack(context),
                const SizedBox(height: AppSpacing.lg),
                // Product Info
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (widget.product.isBestseller)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryFixed,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                              child: Text(
                                'BESTSELLER',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.onPrimaryFixedVariant,
                                      fontWeight: AppTypography.bold,
                                    ),
                              ),
                            )
                          else
                            const SizedBox.shrink(),
                          const Icon(
                            Icons.share_outlined,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        widget.product.title,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: AppTypography.bold,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Text(
                            widget.product.formattedDiscountedPrice,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: AppTypography.bold,
                                ),
                          ),
                          if (widget.product.discountPercent > 0) ...[
                            const SizedBox(width: AppSpacing.md),
                            Text(
                              widget.product.formattedPrice,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.outline,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.tertiaryFixed,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                              child: Text(
                                '${widget.product.discountPercent}% OFF',
                                style: const TextStyle(
                                  color: AppColors.onTertiaryFixedVariant,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      const Divider(),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: AppTypography.bold,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        widget.product.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      _buildSizeSelector(context),
                      const SizedBox(height: 120), // Padding for sticky button
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom Sticky Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Add to Bag',
                      onTap: () {
                        cartProvider.addItem(widget.product, size: _selectedSize);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.product.title} (Size: $_selectedSize) added to bag!'),
                            action: SnackBarAction(
                              label: 'VIEW BAG',
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const CartScreen()),
                                );
                              },
                            ),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      final isFavorite = auth.isProductInWishlist(widget.product.id);
                      return GestureDetector(
                        onTap: () {
                          auth.toggleWishlist(widget.product.id);
                        },
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.outlineVariant),
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? AppColors.primary : AppColors.onSurface,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageStack(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: widget.product.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.surfaceContainer,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.surfaceContainer,
              child: const Icon(Icons.broken_image_outlined, size: 48, color: AppColors.outline),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: AppSpacing.lg,
            child: _blurIconButton(
              context,
              Icons.arrow_back,
              () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blurIconButton(
    BuildContext context,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.onSurface),
      ),
    );
  }

  Widget _buildSizeSelector(BuildContext context) {
    final sizes = widget.product.sizes;
    if (sizes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Size',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Size Guide', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: sizes.map((size) {
            final isSelected = size == _selectedSize;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSize = size;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: AppSpacing.sm),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: isSelected ? null : Border.all(color: AppColors.outlineVariant),
                ),
                alignment: Alignment.center,
                child: Text(
                  size,
                  style: TextStyle(
                    color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                    fontWeight: AppTypography.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
