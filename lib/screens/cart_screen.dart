import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../providers/cart_provider.dart';
import '../widgets/components/app_buttons.dart';
import '../widgets/components/app_navigation.dart';
import '../widgets/components/app_states.dart';
import 'checkout_screen.dart';

import 'wishlist_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;

    return Scaffold(
      appBar: AppTopBar(
        title: 'Shopping Bag',
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
      body: cartItems.isEmpty
          ? const AppEmptyState(
              title: 'Your Bag is Empty',
              description: 'Explore our curated trends and add products to get started.',
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
                    itemBuilder: (context, index) {
                      return _buildCartItem(context, cartItems[index]);
                    },
                  ),
                ),
                _buildSummary(context, cartProvider),
              ],
            ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    CartItem item,
  ) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Format individual item price
    final double itemPrice = item.product.discountedPrice;
    final String formattedItemPrice = 'LKR ${itemPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: CachedNetworkImage(
            imageUrl: item.product.imageUrl,
            width: 100,
            height: 120,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.surfaceContainer,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.product.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: AppTypography.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                    onPressed: () {
                      cartProvider.removeItem(item.product.id, item.size);
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Size: ${item.size} | Category: ${item.product.category}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedItemPrice,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: AppTypography.bold,
                        ),
                  ),
                  _buildQuantityControl(context, item),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityControl(BuildContext context, CartItem item) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 16),
            color: AppColors.onSurfaceVariant,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
            onPressed: () {
              cartProvider.decrementQuantity(item.product.id, item.size);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              item.quantity.toString(),
              style: const TextStyle(fontWeight: AppTypography.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16),
            color: AppColors.onSurfaceVariant,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
            onPressed: () {
              cartProvider.incrementQuantity(item.product.id, item.size);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, CartProvider cartProvider) {
    final subtotalText = 'LKR ${cartProvider.subtotal.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    final totalText = 'LKR ${cartProvider.total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.lg),
          topRight: Radius.circular(AppRadius.lg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal (${cartProvider.itemCount} items)',
                style: const TextStyle(color: AppColors.onSurfaceVariant),
              ),
              Text(
                subtotalText,
                style: const TextStyle(fontWeight: AppTypography.bold),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping',
                style: TextStyle(color: AppColors.onSurfaceVariant),
              ),
              Text(
                'FREE',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: AppTypography.bold,
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.xxl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: AppTypography.bold,
                    ),
              ),
              Text(
                totalText,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: AppTypography.bold,
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Checkout',
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const CheckoutScreen()));
            },
          ),
        ],
      ),
    );
  }
}
