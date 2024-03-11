import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:store_app/api/api_product.dart';
import 'package:store_app/data/sale_image.dart';
import 'package:store_app/models/category.dart';
import 'package:store_app/models/product_item.dart';
import 'package:store_app/screens/product/list_product.dart';
import 'package:store_app/screens/product/product_detail.dart';
import 'package:store_app/screens/product/products.dart';
import 'package:store_app/widgets/category/list_category_hor.dart';
import 'package:store_app/widgets/home/discount_banner.dart';
import 'package:store_app/widgets/home/home_header.dart';
import 'package:store_app/widgets/product/list_product_hor.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.homeScrollController,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  final ScrollController homeScrollController;
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiProduct _apiProduct = ApiProduct();

  Future<List<dynamic>> _getProducts(int page) async {
    try {
      final response = await _apiProduct.getProducts(page, '', {}, '', 0);
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

  void _selectProduct(BuildContext context, ProductItem productItem) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(productItem: productItem),
      ),
    );
  }

  void _selectShowMore(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProductScreen(),
      ),
    );
  }

  Future<List> _getProductPopular(String category) async {
    try {
      final response = await _apiProduct.getPopularProducts();
      final products = response['products'] as List;
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

  void _selectShowMorePopularProduct(BuildContext context) async {
    final products = await _getProductPopular('Popular');
    Category category = const Category(title: 'Popular', image: '');

    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ListProductScreen(
          products: products,
          category: category,
          onGetProductInCategory: _getProductPopular,
        ),
      ),
    );
  }

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
      body: SafeArea(
        child: SingleChildScrollView(
          controller: widget.homeScrollController,
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
                  Container(
                    padding: const EdgeInsets.only(left: 3, right: 3),
                    child: FadeInImage(
                      image: AssetImage(saleImages[0]),
                      placeholder: MemoryImage(kTransparentImage),
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  FutureBuilder(
                    future: _getProductPopular('Popular'),
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
                          onSelectShowMore: _selectShowMorePopularProduct,
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 3, right: 3),
                    child: FadeInImage(
                      image: AssetImage(saleImages[1]),
                      placeholder: MemoryImage(kTransparentImage),
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
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
                          sectionTitle: 'Our Product',
                          onSelectProduct: _selectProduct,
                          products: popularProducts,
                          onSelectShowMore: _selectShowMore,
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 12,
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
