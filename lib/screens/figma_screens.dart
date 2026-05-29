import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class FigmaScreensGallery extends StatefulWidget {
  const FigmaScreensGallery({super.key});

  @override
  State<FigmaScreensGallery> createState() => _FigmaScreensGalleryState();
}

class _FigmaScreensGalleryState extends State<FigmaScreensGallery> {
  int _index = 0;

  static const _screens = <Widget>[
    HomeFigmaScreen(),
    ProductListingFigmaScreen(),
    ProductDetailsFigmaScreen(),
    CartFigmaScreen(),
    CheckoutFigmaScreen(),
    LoginRegistrationFigmaScreen(),
    RegistrationFigmaScreen(),
    ProfileFigmaScreen(),
    PersonalInfoFigmaScreen(),
    AddressesFigmaScreen(),
    OrdersFigmaScreen(),
    NotificationsFigmaScreen(),
    PaymentMethodsFigmaScreen(),
    SettingsFigmaScreen(),
  ];

  static const _titles = <String>[
    'Home',
    'Product Listing',
    'Product Details',
    'Cart',
    'Checkout',
    'Login / Register',
    'Registration',
    'Profile',
    'Personal Info',
    'Addresses',
    'Orders',
    'Notifications',
    'Payment Methods',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 900;
            if (!isDesktop) {
              return Column(
                children: [
                  _GalleryHeader(
                    title: _titles[_index],
                    onNext: () =>
                        setState(() => _index = (_index + 1) % _screens.length),
                    onPrev: () => setState(
                      () => _index =
                          (_index - 1 + _screens.length) % _screens.length,
                    ),
                  ),
                  Expanded(child: _screens[_index]),
                ],
              );
            }
            return Row(
              children: [
                Container(
                  width: 260,
                  padding: const EdgeInsets.all(kSpacingL),
                  color: AppColors.surfaceContainerLow,
                  child: ListView.separated(
                    itemCount: _titles.length,
                    itemBuilder: (_, i) => ListTile(
                      selected: i == _index,
                      selectedTileColor: AppColors.primaryFixed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      title: Text(
                        _titles[i],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      onTap: () => setState(() => _index = i),
                    ),
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: kSpacingS),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _GalleryHeader(
                        title: _titles[_index],
                        onNext: () => setState(
                          () => _index = (_index + 1) % _screens.length,
                        ),
                        onPrev: () => setState(
                          () => _index =
                              (_index - 1 + _screens.length) % _screens.length,
                        ),
                      ),
                      Expanded(child: _screens[_index]),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GalleryHeader extends StatelessWidget {
  const _GalleryHeader({
    required this.title,
    required this.onPrev,
    required this.onNext,
  });

  final String title;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.appBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: kSpacingL),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Row(
        children: [
          IconButton(onPressed: onPrev, icon: const Icon(Icons.chevron_left)),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          IconButton(onPressed: onNext, icon: const Icon(Icons.chevron_right)),
        ],
      ),
    );
  }
}

class HomeFigmaScreen extends StatelessWidget {
  const HomeFigmaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Figma Layer: TopAppBar
          _topRow('ClosetX'),
          const SizedBox(height: kSpacingL),
          // Figma Layer: Search Bar
          const _SearchField(),
          const SizedBox(height: kSpacingL),
          // Figma Layer: New Season Banner
          _bannerCard(
            title: 'Elevate Your Summer Style',
            subtitle: 'New Season',
          ),
          const SizedBox(height: kSpacingXL),
          // Figma Layer: Categories
          _categoryRow(),
          const SizedBox(height: kSpacingXL),
          // Figma Layer: Product Grid
          _simpleGrid(),
        ],
      ),
    );
  }
}

class ProductListingFigmaScreen extends StatelessWidget {
  const ProductListingFigmaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Figma Layer: Hero Banner
          _bannerCard(title: 'Summer Collection \'24', subtitle: 'New Season'),
          const SizedBox(height: kSpacingXL),
          // Figma Layer: Filter Chips
          Wrap(
            spacing: kSpacingS,
            runSpacing: kSpacingS,
            children: const [
              _TagChip('Streetwear'),
              _TagChip('Luxury'),
              _TagChip('Casual'),
              _TagChip('Accessories'),
            ],
          ),
          const SizedBox(height: kSpacingXL),
          _simpleGrid(),
        ],
      ),
    );
  }
}

class ProductDetailsFigmaScreen extends StatelessWidget {
  const ProductDetailsFigmaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Figma Layer: Product Image Stack
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: AspectRatio(
              aspectRatio: 4 / 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: kSpacingL,
                    left: kSpacingL,
                    child: _frostIcon(Icons.arrow_back),
                  ),
                  Positioned(
                    top: kSpacingL,
                    right: kSpacingL,
                    child: _frostIcon(Icons.favorite_border),
                  ),
                  Positioned(
                    left: kSpacingL,
                    right: kSpacingL,
                    bottom: kSpacingL,
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'ClosetX Select',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: AppColors.onPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: kSpacingL),
          Text(
            'Azure Peak Sculpted Coat',
            style: Theme.of(context).textTheme.headlineLarge,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: kSpacingS),
          Row(
            children: [
              Text(
                '\$449.00',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: AppColors.primary),
              ),
              const SizedBox(width: kSpacingM),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kSpacingS,
                  vertical: kSpacingXS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  '25% OFF',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onTertiaryFixedVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpacingXL),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Size Guide'),
                ),
              ),
              const SizedBox(width: kSpacingM),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Add to Bag'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CartFigmaScreen extends StatelessWidget {
  const CartFigmaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _listScreen(
      title: 'Cart',
      items: const [
        ('Azure Minimalist Pack', '\$120.00'),
        ('TechShell Parka V2', '\$285.00'),
        ('Cobalt Loafers', '\$152.00'),
      ],
    );
  }
}

class CheckoutFigmaScreen extends StatelessWidget {
  const CheckoutFigmaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _listScreen(
      title: 'Checkout',
      items: const [
        ('Shipping Address', 'Home'),
        ('Payment Method', 'Visa •••• 4242'),
        ('Order Summary', '3 items'),
      ],
    );
  }
}

class LoginRegistrationFigmaScreen extends StatelessWidget {
  const LoginRegistrationFigmaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _authForm(
      title: 'Welcome Back',
      subtitle: 'Sign in to continue your style journey',
      primaryButton: 'Sign In',
      secondaryButton: 'Create Account',
    );
  }
}

class RegistrationFigmaScreen extends StatelessWidget {
  const RegistrationFigmaScreen({super.key});

  @override
  Widget build(BuildContext context) => _authForm(
    title: 'Create Account',
    subtitle: 'Elevate your style journey',
    primaryButton: 'Create Account',
    secondaryButton: 'Continue with Google',
  );
}

class ProfileFigmaScreen extends StatelessWidget {
  const ProfileFigmaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _PageFrame(
      child: Column(
        children: [
          // Figma Layer: Profile Hero
          ClipOval(
            child: Container(
              width: AppSizes.avatarLg,
              height: AppSizes.avatarLg,
              color: AppColors.secondaryContainer,
              alignment: Alignment.center,
              child: Text(
                'ER',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.onSecondaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(height: kSpacingM),
          Text(
            'Elena Rodriguez',
            style: Theme.of(context).textTheme.headlineMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: kSpacingXL),
          ...const [
            _MenuTile('Personal Information'),
            _MenuTile('Order History'),
            _MenuTile('Payment Methods'),
            _MenuTile('Notifications'),
          ],
        ],
      ),
    );
  }
}

class PersonalInfoFigmaScreen extends StatelessWidget {
  const PersonalInfoFigmaScreen({super.key});

  @override
  Widget build(BuildContext context) => _listScreen(
    title: 'Personal Info',
    items: const [
      ('First Name', 'Elena'),
      ('Last Name', 'Rodriguez'),
      ('Email', 'elena@example.com'),
    ],
  );
}

class AddressesFigmaScreen extends StatelessWidget {
  const AddressesFigmaScreen({super.key});

  @override
  Widget build(BuildContext context) => _listScreen(
    title: 'Addresses',
    items: const [
      ('Primary Address', '2408 W 34th St, New York'),
      ('Office Address', '220 Madison Ave, New York'),
      ('Add New Address', 'Tap to add'),
    ],
  );
}

class OrdersFigmaScreen extends StatelessWidget {
  const OrdersFigmaScreen({super.key});

  @override
  Widget build(BuildContext context) => _listScreen(
    title: 'Orders',
    items: const [
      ('Order #30219', 'Delivered'),
      ('Order #30192', 'In Transit'),
    ],
  );
}

class NotificationsFigmaScreen extends StatelessWidget {
  const NotificationsFigmaScreen({super.key});

  @override
  Widget build(BuildContext context) => _listScreen(
    title: 'Notifications',
    items: const [
      ('Your order has shipped', '10:45 PM'),
      ('Price drop alert', 'Today'),
      ('New arrivals this week', 'Yesterday'),
    ],
  );
}

class PaymentMethodsFigmaScreen extends StatelessWidget {
  const PaymentMethodsFigmaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Figma Layer: Credit Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(kSpacingL),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '**** **** **** 4242',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: AppColors.onPrimary),
                ),
                const SizedBox(height: kSpacing3XL),
                Text(
                  'ALEX JOHNSON',
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: AppColors.onPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: kSpacingXL),
          const _TagChip('FAST CHECKOUT'),
          const SizedBox(height: kSpacingXL),
          _MenuTile('Digital Wallet'),
        ],
      ),
    );
  }
}

class SettingsFigmaScreen extends StatelessWidget {
  const SettingsFigmaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _listScreen(
      title: 'Settings',
      items: const [
        ('Appearance', 'Dark mode, fidelity'),
        ('Privacy', 'Profile and data usage'),
        ('Notification Channels', 'Snap, runway, email'),
        ('Security & Permissions', 'Password, sessions'),
      ],
    );
  }
}

class _PageFrame extends StatelessWidget {
  const _PageFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = constraints.maxWidth < 600
            ? kSpacingL
            : constraints.maxWidth < 900
            ? kSpacingXL
            : kSpacing3XL;
        final maxWidth = constraints.maxWidth > 900 ? 900.0 : double.infinity;

        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontal,
                  vertical: kSpacingL,
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _listScreen({
  required String title,
  required List<(String, String)> items,
}) {
  return Builder(
    builder: (context) => _PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: kSpacingL),
          ListView.separated(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) =>
                _MenuTile(items[index].$1, subtitle: items[index].$2),
            separatorBuilder: (_, _) => const SizedBox(height: kSpacingM),
          ),
        ],
      ),
    ),
  );
}

Widget _topRow(String brand) {
  return Row(
    children: [
      Expanded(
        child: Text(
          brand,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: AppTypography.size20,
            fontWeight: AppTypography.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(width: kSpacingS),
      const Icon(
        Icons.menu,
        size: AppSizes.iconMd,
        color: AppColors.onSurfaceVariant,
      ),
      const Spacer(),
      const Icon(
        Icons.shopping_bag_outlined,
        size: AppSizes.iconMd,
        color: AppColors.onSurfaceVariant,
      ),
    ],
  );
}

Widget _bannerCard({required String title, required String subtitle}) {
  return Container(
    height: AppSizes.bannerHeight,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      gradient: const LinearGradient(
        colors: [AppColors.primary, AppColors.primaryContainer],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(kSpacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.primaryFixed,
              fontSize: AppTypography.size12,
              fontWeight: AppTypography.bold,
            ),
          ),
          const Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.onPrimary,
                fontSize: AppTypography.size30,
                fontWeight: AppTypography.extrabold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _categoryRow() {
  final items = ['Outfits', 'Jewelry', 'Shoes', 'Eyewear', 'Bags'];
  return SizedBox(
    height: 84,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, i) => SizedBox(
        width: 72,
        child: Column(
          children: [
            ClipOval(
              child: Container(
                width: 56,
                height: 56,
                color: i == 0
                    ? AppColors.primaryContainer
                    : AppColors.surfaceContainerHigh,
                child: Icon(
                  Icons.checkroom_outlined,
                  color: i == 0
                      ? AppColors.onPrimaryContainer
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: kSpacingXS),
            Text(
              items[i],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: AppTypography.size12),
            ),
          ],
        ),
      ),
      separatorBuilder: (_, _) => const SizedBox(width: kSpacingM),
      itemCount: items.length,
    ),
  );
}

Widget _simpleGrid() {
  final products = [
    ('Azure Minimalist Pack', '\$120.00'),
    ('TechShell Parka V2', '\$285.00'),
    ('Cobalt Loafers', '\$152.00'),
    ('SkyHigh Retros', '\$135.00'),
  ];
  return LayoutBuilder(
    builder: (context, constraints) {
      final crossAxisCount = constraints.maxWidth > 900
          ? 4
          : constraints.maxWidth >= 600
          ? 3
          : 2;
      return GridView.builder(
        itemCount: products.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: kSpacingM,
          mainAxisSpacing: kSpacingM,
          childAspectRatio: 0.67,
        ),
        itemBuilder: (_, i) => Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.lg),
                    topRight: Radius.circular(AppRadius.lg),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: 'https://picsum.photos/seed/$i/500/700',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(kSpacingS),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        products[i].$1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: AppTypography.bold,
                        ),
                      ),
                      const SizedBox(height: kSpacingXS),
                      Text(
                        products[i].$2,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _authForm({
  required String title,
  required String subtitle,
  required String primaryButton,
  required String secondaryButton,
}) {
  return _PageFrame(
    child: LayoutBuilder(
      builder: (context, constraints) {
        final bool wide = constraints.maxWidth >= 600;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Figma Layer: Header
            Text(
              title,
              style: Theme.of(context).textTheme.displayMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: kSpacingS),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: kSpacingXL),
            // Figma Layer: Form
            if (wide)
              Row(
                children: const [
                  Expanded(child: _SearchField(hint: 'First Name')),
                  SizedBox(width: kSpacingM),
                  Expanded(child: _SearchField(hint: 'Last Name')),
                ],
              )
            else ...const [
              _SearchField(hint: 'First Name'),
              SizedBox(height: kSpacingM),
              _SearchField(hint: 'Last Name'),
            ],
            const SizedBox(height: kSpacingM),
            const _SearchField(hint: 'Email'),
            const SizedBox(height: kSpacingM),
            const _SearchField(hint: 'Password'),
            const SizedBox(height: kSpacingXL),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(primaryButton),
              ),
            ),
            const SizedBox(height: kSpacingM),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: Text(secondaryButton),
              ),
            ),
          ],
        );
      },
    ),
  );
}

Widget _frostIcon(IconData icon) {
  return ClipOval(
    child: Container(
      width: 36,
      height: 36,
      color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9),
      child: Icon(icon, size: AppSizes.iconMd, color: AppColors.onSurface),
    ),
  );
}

class _TagChip extends StatelessWidget {
  const _TagChip(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kSpacingM,
        vertical: kSpacingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({this.hint = 'Search'});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.searchHeight,
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.outline),
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile(this.title, {this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: kSpacingXS),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
