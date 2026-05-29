import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../utils/responsive_helper.dart';
import '../widgets/components/app_buttons.dart';
import '../widgets/components/app_icons.dart';
import '../widgets/components/app_input_field.dart';
import '../widgets/components/app_navigation.dart';
import '../widgets/components/app_states.dart';
import '../widgets/components/app_surfaces.dart';

/// Isolated gallery to test each reusable component and interaction state.
class ComponentsShowcaseScreen extends StatefulWidget {
  const ComponentsShowcaseScreen({super.key});

  @override
  State<ComponentsShowcaseScreen> createState() => _ComponentsShowcaseScreenState();
}

class _ComponentsShowcaseScreenState extends State<ComponentsShowcaseScreen> {
  int _tab = 0;
  bool _showLoading = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double pad = ResponsiveHelper.horizontalPadding(context);
    final bool compact = ResponsiveHelper.isMobile(context);

    return Scaffold(
      appBar: const AppTopBar(
        title: 'Component Library',
        actions: [Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.tune))],
      ),
      body: _showLoading
          ? const AppLoadingState()
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(pad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Buttons', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.md,
                      children: [
                        SizedBox(
                          width: compact ? double.infinity : 220,
                          child: AppButton(
                            label: 'Primary',
                            onTap: () {},
                            leading: const Icon(Icons.shopping_bag_outlined),
                          ),
                        ),
                        SizedBox(
                          width: compact ? double.infinity : 220,
                          child: AppButton(
                            label: 'Secondary',
                            variant: AppButtonVariant.secondary,
                            onTap: () {},
                          ),
                        ),
                        SizedBox(
                          width: compact ? double.infinity : 220,
                          child: const AppButton(
                            label: 'Disabled',
                            variant: AppButtonVariant.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text('Inputs', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.md),
                    AppInputField(
                      label: 'Email Address',
                      hintText: 'alex@example.com',
                      controller: _controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Email is required';
                        if (!value.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const AppInputField(
                      label: 'Disabled Field',
                      hintText: 'Disabled state',
                      enabled: false,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text('Cards & Lists', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.md),
                    const AppListItem(
                      title: 'Premium Streetwear',
                      subtitle: '2 items available in your size',
                      leading: AppCircularIcon(
                        child: AppIcon(icon: Icons.local_fire_department_outlined),
                      ),
                      trailing: AppIcon(icon: Icons.chevron_right),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: compact ? 1 : 2,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: compact ? 2.2 : 1.2,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        AppGridItem(title: 'Azure Minimalist Pack', price: '\$120.00'),
                        AppGridItem(title: 'TechShell Parka V2', price: '\$285.00'),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text('Icons & SVG', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.md),
                    const Row(
                      children: [
                        AppIcon(icon: Icons.explore_outlined),
                        SizedBox(width: AppSpacing.md),
                        AppIcon(
                          svgString:
                              '<svg viewBox="0 0 24 24"><path d="M12 2L15 9L22 9L16.5 13.5L18.5 21L12 16.8L5.5 21L7.5 13.5L2 9L9 9L12 2Z" fill="#005AB4"/></svg>',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text('States', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: _showLoading ? 'Show Empty' : 'Show Loading',
                            variant: AppButtonVariant.secondary,
                            onTap: () => setState(() => _showLoading = !_showLoading),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const AppEmptyState(
                      title: 'Nothing Here Yet',
                      description:
                          'Your curated list is empty. Start exploring and save products to see them here.',
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _tab,
        onTap: (index) => setState(() => _tab = index),
        items: const [
          AppBottomNavItem(label: 'Discover', icon: Icons.explore_outlined),
          AppBottomNavItem(label: 'Runway', icon: Icons.movie_outlined),
          AppBottomNavItem(label: 'Profile', icon: Icons.person_outline),
        ],
      ),
    );
  }
}
