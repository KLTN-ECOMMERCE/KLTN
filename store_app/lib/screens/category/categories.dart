

import 'package:flutter/material.dart';
import 'package:store_app/models/category.dart';
import 'package:store_app/screens/product/products.dart';
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

  void _selectCategory(BuildContext context, Category category) async {
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductScreen(
          category: category.title,
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
