import 'dart:io';

import 'package:flutter/material.dart';
import 'package:store_app/api/api_product.dart';
import 'package:store_app/models/category.dart';
import 'package:store_app/models/product_item.dart';
import 'package:store_app/screens/product/list_product.dart';
import 'package:store_app/screens/product/product_detail.dart';
import 'package:store_app/widgets/category/list_category_hor.dart';
import 'package:store_app/widgets/home/discount_banner.dart';
import 'package:store_app/widgets/home/home_header.dart';
import 'package:store_app/widgets/product/list_product_hor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiProduct _apiProduct = ApiProduct();

  Future<List<dynamic>> _getProducts(int page) async {
    try {
      final response = await _apiProduct.getProducts(
        page,
        '',
        {},
      );
      final products = response['products'] as List<dynamic>;
      return products;
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
  }

  void _selectProduct(BuildContext context, ProductItem productItem) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(productItem: productItem),
      ),
    );
  }

  Future<List> _getProductsInCategory(String category) async {
    try {
      final response = await _apiProduct.getProductsInCategory(category);
      final products = response['product'] as List;
      return products;
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

  void _selectCategory(BuildContext context, Category category) async {
    final products = await _getProductsInCategory(category.title);
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ListProductScreen(
          products: products,
          category: category,
          onGetProductInCategory: _getProductsInCategory,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  const HomeHeader(),
                  const DiscountBanner(
                    firstString: 'Welcome to E-Shop',
                    secondString: 'Special Month: Sale off to 20%',
                  ),
                  ListCategoryHor(
                    sectionTitle: 'Special for you',
                    onSelectCategory: _selectCategory,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  FutureBuilder(
                    future: _getProducts(1),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                        );
                      } else {
                        final popularProducts = snapshot.data as List<dynamic>;
                        return ListProductHor(
                          sectionTitle: 'Popular Products',
                          onSelectProduct: _selectProduct,
                          products: popularProducts,
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  FutureBuilder(
                    future: _getProducts(2),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                        );
                      } else {
                        final popularProducts = snapshot.data as List<dynamic>;
                        return ListProductHor(
                          sectionTitle: 'Best Seller',
                          onSelectProduct: _selectProduct,
                          products: popularProducts,
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  FutureBuilder(
                    future: _getProducts(3),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                        );
                      } else {
                        final popularProducts = snapshot.data as List<dynamic>;
                        return ListProductHor(
                          sectionTitle: 'Professional',
                          onSelectProduct: _selectProduct,
                          products: popularProducts,
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  FutureBuilder(
                    future: _getProducts(4),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                        );
                      } else {
                        final popularProducts = snapshot.data as List<dynamic>;
                        return ListProductHor(
                          sectionTitle: 'For Family',
                          onSelectProduct: _selectProduct,
                          products: popularProducts,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
