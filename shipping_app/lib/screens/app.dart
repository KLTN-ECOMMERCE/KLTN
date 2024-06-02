import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shipping_app/api/api_shipper.dart';
import 'package:shipping_app/api/api_user.dart';
import 'package:shipping_app/screens/home.dart';
import 'package:shipping_app/screens/orders/orders.dart';
import 'package:shipping_app/screens/profile/profile.dart';

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
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
  );
  final ApiShipper _apiShipper = ApiShipper();
  final ApiUser _apiUser = ApiUser();

  int _currentPageIndex = 0;

  Future<List> _getOrdersByShippingUnit() async {
    try {
      final response = await _apiShipper.getOrderByShippingUnit();
      final orders = response as List;
      return orders;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> _getUserProfile() async {
    try {
      final response = await _apiUser.getProfile();
      final profile = response['user'];
      return profile;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> _getShipper() async {
    try {
      final response = await _apiShipper.getShipper();
      final shippers = response['shipper'] as List;
      final shipper = shippers[0];
      return shipper;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
      throw HttpException(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
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
          HomeScreen(
            homeScrollController: _scrollController,
            getUserProfile: _getUserProfile,
            getOrdersByShippingUnit: _getOrdersByShippingUnit,
            getShipper: _getShipper,
          ),
          OrdersScreen(
            getOrdersByShippingUnit: _getOrdersByShippingUnit,
            homeScrollController: _scrollController,
          ),
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
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
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
    );
  }
}
