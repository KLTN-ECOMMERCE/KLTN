import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/models/category.dart';
import 'package:store_app/models/product_item.dart';
import 'package:store_app/providers/favorite_products_provider.dart';
import 'package:store_app/screens/app.dart';
import 'package:store_app/screens/product/product_detail.dart';
import 'package:store_app/screens/product/products.dart';
import 'package:store_app/widgets/category/list_category_hor.dart';
import 'package:store_app/widgets/home/home_header.dart';
import 'package:store_app/widgets/product/large_product_item.dart';

class FavoriteProductsScreen extends ConsumerStatefulWidget {
  const FavoriteProductsScreen({
    super.key,
    required this.homeScrollController,
  });
  final ScrollController homeScrollController;

  @override
  ConsumerState<FavoriteProductsScreen> createState() {
    return _FavoriteProductsState();
  }
}

class _FavoriteProductsState extends ConsumerState<FavoriteProductsScreen> {
  void _selectCategory(BuildContext context, Category category) {
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductScreen(
          category: category.title,
        ),
      ),
    );
  }

  void _selectProduct(BuildContext context, ProductItem productItem) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(productItem: productItem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final data = ref.watch(favoriteProductsDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        foregroundColor: onPrimary,
        backgroundColor: primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: widget.homeScrollController,
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 8,
          ),
          child: Column(
            children: [
              const HomeHeader(),
              ListCategoryHor(
                sectionTitle: 'Explore now',
                onSelectCategory: _selectCategory,
              ),
              FutureBuilder(
                future: data,
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
                    final favoriteProducts = snapshot.data;
                    if (favoriteProducts!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Uh no ... nothing here !!!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const AppScreen(
                                      currentIndex: 0,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.arrow_back_ios_sharp),
                              label: const Text(
                                'SHOP NOW',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  wordSpacing: 8,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                          bottom: 20,
                          top: 20,
                          right: 4,
                          left: 4,
                        ),
                        child: Column(
                          children: [
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: favoriteProducts.length,
                              itemBuilder: (context, index) {
                                return LargeProductItem(
                                  productItem: favoriteProducts[index],
                                  onSelectProduct: _selectProduct,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
