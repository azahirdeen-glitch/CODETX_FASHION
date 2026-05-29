import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../widgets/components/app_buttons.dart';
import '../widgets/components/app_input_field.dart';
import '../widgets/components/app_navigation.dart';
import '../widgets/components/app_surfaces.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  void _showAddCardSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddCardBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cards = authProvider.userModel?.paymentCards ?? [];

    return Scaffold(
      appBar: AppTopBar(
        title: 'Payment Methods',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: cards.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.credit_card_off_outlined, size: 64, color: AppColors.outline),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No Saved Cards',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      'Add a payment method securely to place orders instantly.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: cards.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final card = cards[index];
                return _buildPremiumCard(context, card, authProvider);
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AppButton(
            label: '+ Add New Card',
            onTap: () => _showAddCardSheet(context),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumCard(BuildContext context, PaymentCardModel card, AuthProvider authProvider) {
    final isDefault = card.isDefault;

    return Column(
      children: [
        AppCardSurface(
          backgroundColor: isDefault ? AppColors.primary : AppColors.secondary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    card.cardType.toUpperCase(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.8),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Row(
                    children: [
                      if (isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: const Text(
                            'DEFAULT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(width: AppSpacing.sm),
                      GestureDetector(
                        onTap: () {
                          authProvider.deleteCard(card.id);
                        },
                        child: const Icon(Icons.delete_outline, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                card.cardNumber,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: AppTypography.bold,
                      letterSpacing: 2.5,
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
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                      ),
                      Text(
                        card.cardHolder.toUpperCase(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
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
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                      ),
                      Text(
                        card.expiryDate,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isDefault) ...[
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: const Icon(Icons.check, size: 14),
              label: const Text('Set as Default Card', style: TextStyle(fontSize: 12)),
              onPressed: () {
                authProvider.setDefaultCard(card.id);
              },
            ),
          ),
        ] else
          const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

class AddCardBottomSheet extends StatefulWidget {
  const AddCardBottomSheet({super.key});

  @override
  State<AddCardBottomSheet> createState() => _AddCardBottomSheetState();
}

class _AddCardBottomSheetState extends State<AddCardBottomSheet> {
  final _holderController = TextEditingController();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  String _cardType = 'Visa';
  bool _isDefault = false;

  @override
  void dispose() {
    _holderController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _submit() async {
    final holder = _holderController.text.trim();
    final number = _numberController.text.trim();
    final expiry = _expiryController.text.trim();
    final cvv = _cvvController.text.trim();

    if (holder.isEmpty || number.isEmpty || expiry.isEmpty || cvv.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Mask card number for display: "**** **** **** 4242"
    String masked = number;
    if (number.length >= 4) {
      final lastFour = number.substring(number.length - 4);
      masked = '**** **** **** $lastFour';
    }

    final newCard = PaymentCardModel(
      id: 'CARD-${DateTime.now().millisecondsSinceEpoch}',
      cardType: _cardType,
      cardNumber: masked,
      cardHolder: holder,
      expiryDate: expiry,
      cvv: cvv,
      isDefault: _isDefault,
    );

    try {
      await Provider.of<AuthProvider>(context, listen: false).addPaymentCard(newCard);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Card added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.lg),
          topRight: Radius.circular(AppRadius.lg),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Add New Payment Card',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<String>(
              initialValue: _cardType,
              decoration: const InputDecoration(
                labelText: 'Card Brand Type',
                border: OutlineInputBorder(),
              ),
              items: ['Visa', 'MasterCard', 'Amex']
                  .map((brand) => DropdownMenuItem(
                        value: brand,
                        child: Text(brand),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _cardType = val;
                  });
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppInputField(
              controller: _holderController,
              label: 'Card Holder Name',
              hintText: 'ELENA RODRIGUEZ',
            ),
            const SizedBox(height: AppSpacing.md),
            AppInputField(
              controller: _numberController,
              label: '16-Digit Card Number',
              hintText: '4111222233334444',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppInputField(
                    controller: _expiryController,
                    label: 'Expiry Date',
                    hintText: '12/28',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppInputField(
                    controller: _cvvController,
                    label: 'CVV',
                    hintText: '123',
                    obscureText: true,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            SwitchListTile(
              title: const Text('Set as Default Payment Card'),
              value: _isDefault,
              onChanged: (val) {
                setState(() {
                  _isDefault = val;
                });
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Add Card Securely',
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
