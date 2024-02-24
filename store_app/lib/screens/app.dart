import 'package:flutter/material.dart';
import 'package:store_app/screens/home.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<AppScreen> {
  final ScrollController _scrollController = ScrollController();
  int currentPageIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          if (currentPageIndex == value) {
            _scrollController.animateTo(
              0.0,
              duration: const Duration(
                milliseconds: 500,
              ),
              curve: Curves.easeOut,
            );
          }
          setState(() {
            currentPageIndex = value;
          });
        },
        indicatorColor: theme.colorScheme.primary,
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.shopping_bag),
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Cart',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite_outlined),
            icon: Icon(Icons.favorite_border),
            label: 'Favorite',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.local_shipping),
            icon: Icon(Icons.local_shipping_outlined),
            label: 'My Orders',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.manage_accounts),
            icon: Icon(Icons.manage_accounts_outlined),
            label: 'Profile',
          ),
        ],
      ),
      body: [
        HomeScreen(
          homeController: _scrollController,
        ),
        const Text('2'),
        const Text('3'),
        const Text('4'),
        const Text('5'),
      ][currentPageIndex],
    );
  }
}
