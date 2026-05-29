import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/components/app_buttons.dart';
import '../widgets/components/app_navigation.dart';
import '../widgets/components/app_surfaces.dart';
import 'main_screen.dart';


class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);


    final user = authProvider.userModel;

    // Get default address or first address
    AddressModel? selectedAddress;
    if (user != null && user.addresses.isNotEmpty) {
      selectedAddress = user.addresses.firstWhere(
        (addr) => addr.isDefault,
        orElse: () => user.addresses.first,
      );
    }

    // Get default card or first card
    PaymentCardModel? selectedCard;
    if (user != null && user.paymentCards.isNotEmpty) {
      selectedCard = user.paymentCards.firstWhere(
        (card) => card.isDefault,
        orElse: () => user.paymentCards.first,
      );
    }

    final subtotalText = 'LKR ${cartProvider.subtotal.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    final taxText = 'LKR ${cartProvider.tax.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    final totalText = 'LKR ${cartProvider.total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';

    return Scaffold(
      appBar: AppTopBar(
        title: 'Checkout',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'Shipping Address', () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please update addresses in your Profile Settings')),
              );
            }),
            if (selectedAddress != null)
              AppListItem(
                title: selectedAddress.name,
                subtitle: '${selectedAddress.street}\n${selectedAddress.city}, ${selectedAddress.state} ${selectedAddress.zip}\n${selectedAddress.country}',
                leading: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                ),
                trailing: const Icon(Icons.chevron_right, size: 20),
              )
            else
              AppCardSurface(
                backgroundColor: AppColors.surfaceContainerLow,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_off_outlined, color: AppColors.outline),
                        const SizedBox(width: AppSpacing.md),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No Shipping Address Saved',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Add one in your profile to complete checkout.',
                                style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add_location_alt_outlined, size: 16),
                        label: const Text('Add Address in Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const MainScreen(initialIndex: 3)),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: AppSpacing.xxl),
            _buildSectionHeader(context, 'Payment Method', () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please update cards in your Profile Settings')),
              );
            }),
            if (selectedCard != null)
              AppCardSurface(
                backgroundColor: AppColors.primary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedCard.cardType,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: AppColors.onPrimary.withValues(alpha: 0.8),
                              ),
                        ),
                        const Icon(Icons.credit_card, color: AppColors.onPrimary),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      selectedCard.cardNumber,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: AppTypography.bold,
                            letterSpacing: 2,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CARD HOLDER',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.onPrimary.withValues(alpha: 0.6),
                                  ),
                            ),
                            Text(
                              selectedCard.cardHolder.toUpperCase(),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EXPIRES',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.onPrimary.withValues(alpha: 0.6),
                                  ),
                            ),
                            Text(
                              selectedCard.expiryDate,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else
              AppCardSurface(
                backgroundColor: AppColors.surfaceContainerLow,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.credit_card_off_outlined, color: AppColors.outline),
                        const SizedBox(width: AppSpacing.md),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No Payment Card Saved',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Add one in your profile to complete checkout.',
                                style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add_card_outlined, size: 16),
                        label: const Text('Add Card in Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const MainScreen(initialIndex: 3)),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: AppSpacing.xxl),
            _buildSectionHeader(context, 'Order Summary', () {}),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                children: [
                  _summaryRow('Subtotal', subtotalText),
                  const SizedBox(height: AppSpacing.sm),
                  _summaryRow('Shipping', 'FREE'),
                  const SizedBox(height: AppSpacing.sm),
                  _summaryRow('Tax (8%)', taxText),
                  const Divider(height: AppSpacing.xl),
                  _summaryRow(
                    'Total',
                    totalText,
                    isBold: true,
                    isPrimary: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            Consumer<OrderProvider>(
              builder: (context, order, _) {
                if (order.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return AppButton(
                  label: 'Place Order',
                  onTap: () async {
                    if (selectedAddress == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please add a shipping address in your profile first!'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      return;
                    }
                    if (selectedCard == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please add a payment card in your profile first!'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      return;
                    }

                    try {
                      // Map CartItems to OrderItemModels
                      final List<OrderItemModel> items = cartProvider.items.map((item) {
                        return OrderItemModel(
                          productId: item.product.id,
                          title: item.product.title,
                          imageUrl: item.product.imageUrl,
                          price: item.product.discountedPrice,
                          quantity: item.quantity,
                          size: item.size,
                        );
                      }).toList();

                      await order.checkout(
                        userId: authProvider.firebaseUser!.uid,
                        items: items,
                        subtotal: cartProvider.subtotal,
                        tax: cartProvider.tax,
                        totalAmount: cartProvider.total,
                        shippingAddress: selectedAddress,
                        paymentCard: selectedCard,
                      );

                      // Clear Cart
                      cartProvider.clearCart();

                      // Show Success Dialog
                      if (context.mounted) {
                        _showSuccess(context);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to place order: $e'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onChange) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onChange,
            child: const Text('Change', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  static Widget _summaryRow(
    String label,
    String value, {
    bool isBold = false,
    bool isPrimary = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? AppColors.onSurface : AppColors.onSurfaceVariant,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isPrimary ? AppColors.primary : AppColors.onSurface,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }

  void _showSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Order Placed!'),
        content: const Text(
          'Your order has been placed successfully. Thank you for shopping with ClosetX.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainScreen(initialIndex: 0)), // 0 is Home
                (route) => false,
              );
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}
