import 'dart:io';

import 'package:flutter/material.dart';
import 'package:store_app/api/api_product.dart';
import 'package:store_app/models/category.dart';
import 'package:store_app/screens/product/list_product.dart';
import 'package:store_app/widgets/category/list_category_ver.dart';
import 'package:store_app/widgets/home/discount_banner.dart';
import 'package:store_app/widgets/home/home_header.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() {
    return _CategoryState();
  }
}

class _CategoryState extends State<CategoriesScreen> {
  final ApiProduct _apiProduct = ApiProduct();

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
      appBar: AppBar(
        title: const Text(
          'Categories',
        ),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const HomeHeader(),
              const DiscountBanner(
                firstString: 'Explore Categories of E-Shop',
                secondString: 'Happy New Year: Sale off to 22%',
              ),
              ListCategoryVer(
                onSelectCategory: _selectCategory,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
