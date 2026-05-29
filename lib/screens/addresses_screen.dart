import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../widgets/components/app_buttons.dart';
import '../widgets/components/app_input_field.dart';
import '../widgets/components/app_navigation.dart';
import '../widgets/components/app_surfaces.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  void _showAddAddressSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddAddressBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final addresses = authProvider.userModel?.addresses ?? [];

    return Scaffold(
      appBar: AppTopBar(
        title: 'Shipping Addresses',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: addresses.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_off_outlined, size: 64, color: AppColors.outline),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No Addresses Saved',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      'Add your delivery addresses to streamline your checkout process.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: addresses.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final address = addresses[index];
                return AppCardSurface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            address.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: AppTypography.bold,
                                ),
                          ),
                          Row(
                            children: [
                              if (address.isDefault)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer,
                                    borderRadius: BorderRadius.circular(AppRadius.sm),
                                  ),
                                  child: const Text(
                                    'Default',
                                    style: TextStyle(
                                      color: AppColors.onPrimaryContainer,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                                onPressed: () {
                                  authProvider.deleteAddress(address.id);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${address.street}\n${address.city}, ${address.state} ${address.zip}\n${address.country}',
                        style: const TextStyle(height: 1.4, color: AppColors.onSurfaceVariant),
                      ),
                      if (!address.isDefault) ...[
                        const Divider(height: AppSpacing.lg),
                        TextButton.icon(
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Set as Default'),
                          onPressed: () {
                            authProvider.setDefaultAddress(address.id);
                          },
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AppButton(
            label: '+ Add New Address',
            onTap: () => _showAddAddressSheet(context),
          ),
        ),
      ),
    );
  }
}

class AddAddressBottomSheet extends StatefulWidget {
  const AddAddressBottomSheet({super.key});

  @override
  State<AddAddressBottomSheet> createState() => _AddAddressBottomSheetState();
}

class _AddAddressBottomSheetState extends State<AddAddressBottomSheet> {
  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();
  bool _isDefault = false;

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _submit() async {
    final name = _nameController.text.trim();
    final street = _streetController.text.trim();
    final city = _cityController.text.trim();
    final state = _stateController.text.trim();
    final zip = _zipController.text.trim();
    final country = _countryController.text.trim();

    if (name.isEmpty || street.isEmpty || city.isEmpty || zip.isEmpty || country.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final newAddress = AddressModel(
      id: 'ADDR-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      street: street,
      city: city,
      state: state,
      zip: zip,
      country: country,
      isDefault: _isDefault,
    );

    try {
      await Provider.of<AuthProvider>(context, listen: false).addAddress(newAddress);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address added successfully!'),
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
              'Add New Address',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppInputField(
              controller: _nameController,
              label: 'Address Label (e.g. Home, Work)*',
              hintText: 'Home',
            ),
            const SizedBox(height: AppSpacing.md),
            AppInputField(
              controller: _streetController,
              label: 'Street Address*',
              hintText: '123 Fashion Ave',
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppInputField(
                    controller: _cityController,
                    label: 'City*',
                    hintText: 'Colombo',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppInputField(
                    controller: _stateController,
                    label: 'State/Region',
                    hintText: 'Western',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppInputField(
                    controller: _zipController,
                    label: 'Postal Code*',
                    hintText: '00100',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppInputField(
                    controller: _countryController,
                    label: 'Country*',
                    hintText: 'Sri Lanka',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            SwitchListTile(
              title: const Text('Set as Default Shipping Address'),
              value: _isDefault,
              onChanged: (val) {
                setState(() {
                  _isDefault = val;
                });
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Add Address',
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
