import 'package:flutter/material.dart';
import '../widgets/components/app_navigation.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import 'product_listing_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProductListingScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          AppBottomNavItem(label: 'Discover', icon: Icons.explore_outlined),
          AppBottomNavItem(label: 'Runway', icon: Icons.movie_outlined),
          AppBottomNavItem(label: 'Bag', icon: Icons.shopping_bag_outlined),
          AppBottomNavItem(label: 'Profile', icon: Icons.person_outline),
        ],
      ),
    );
  }
}
