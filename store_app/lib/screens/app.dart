import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:store_app/screens/cart/cart.dart';
import 'package:store_app/screens/home.dart';
import 'package:store_app/screens/order/my_orders.dart';
import 'package:store_app/screens/profile/profile.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;

  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<AppScreen> {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0.0);
  final storage = const FlutterSecureStorage();
  String _token = '';

  Future<String> _getToken() async {
    final token = await storage.read(key: 'access-token');
    if (token == null) return '';
    return token;
  }

  int _currentPageIndex = 0;
  @override
  void initState() {
    super.initState();
    _getToken().then((value) {
      setState(() {
        _token = value;
      });
    });
    _currentPageIndex = widget.currentIndex;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _currentPageIndex,
        children: [
          HomeScreen(homeScrollController: _scrollController),
          CartScreen(homeScrollController: _scrollController),
          Text(_token),
          const MyOrdersScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          if (_currentPageIndex == value) {
            _scrollController.animateTo(
              0.0,
              duration: const Duration(
                milliseconds: 500,
              ),
              curve: Curves.easeOut,
            );
          }
          setState(() {
            _currentPageIndex = value;
          });
        },
        indicatorColor: theme.colorScheme.primary,
        selectedIndex: _currentPageIndex,
        destinations: [
          const NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.shopping_bag),
            icon: PersistentShoppingCart().showCartItemCountWidget(
              cartItemCountWidgetBuilder: (itemCount) {
                if (itemCount != 0) {
                  return Badge(
                    label: Text(itemCount.toString()),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                    ),
                  );
                } else {
                  return const Icon(
                    Icons.shopping_bag_outlined,
                  );
                }
              },
            ),
            label: 'Cart',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Icons.favorite_outlined),
            icon: Icon(Icons.favorite_border),
            label: 'Favorite',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Icons.local_shipping),
            icon: Icon(Icons.local_shipping_outlined),
            label: 'My Orders',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Icons.manage_accounts),
            icon: Icon(Icons.manage_accounts_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
