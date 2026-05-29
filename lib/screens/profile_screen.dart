import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../providers/auth_provider.dart';
import '../widgets/components/app_navigation.dart';
import '../widgets/components/app_surfaces.dart';
import 'personal_info_screen.dart';
import 'addresses_screen.dart';
import 'payment_methods_screen.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.userModel;

    return Scaffold(
      appBar: const AppTopBar(title: 'Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            // Profile Header
            if (user != null)
              _buildProfileHeader(context, authProvider)
            else
              const Center(child: CircularProgressIndicator()),
            
            const SizedBox(height: AppSpacing.xxxl),
            
            // Menu Items
            AppListItem(
              title: 'Personal Information',
              leading: const Icon(Icons.person_outline, color: AppColors.primary),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PersonalInfoScreen()),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppListItem(
              title: 'Shipping Addresses',
              leading: const Icon(Icons.location_on_outlined, color: AppColors.primary),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddressesScreen()),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppListItem(
              title: 'Payment Methods',
              leading: const Icon(Icons.credit_card_outlined, color: AppColors.primary),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppListItem(
              title: 'Order History',
              leading: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppListItem(
              title: 'Settings',
              leading: const Icon(Icons.settings_outlined, color: AppColors.primary),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings are fully optimized.')),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xxxl),
            
            // Log Out Button
            Consumer<AuthProvider>(
              builder: (context, auth, _) {
                if (auth.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return AppCardSurface(
                  backgroundColor: AppColors.errorContainer.withValues(alpha: 0.1),
                  onTap: () async {
                    try {
                      await auth.logout();
                      // Navigation to LoginScreen will automatically occur via AuthWrapper in main.dart
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Log out failed: $e')),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout, color: AppColors.error),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Log Out',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.error,
                              fontWeight: AppTypography.bold,
                            ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.userModel!;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondaryContainer,
                    AppColors.primaryFixed,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                user.initials,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.onSecondaryContainer,
                      fontWeight: AppTypography.bold,
                    ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PersonalInfoScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: AppColors.onPrimary,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          user.fullName,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: AppTypography.bold),
        ),
        Text(
          user.email,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}
