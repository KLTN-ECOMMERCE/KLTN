import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:store_app/api/api_product.dart';
import 'package:store_app/models/product_item.dart';
import 'package:store_app/providers/favorites_provider.dart';
import 'package:store_app/providers/viewed_products_provider.dart';
import 'package:store_app/providers/viewed_provider.dart';
import 'package:store_app/widgets/product/product_detail/product_description.dart';
import 'package:store_app/widgets/product/product_detail/product_images.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:store_app/widgets/product/product_detail/product_reviews.dart';
import 'package:store_app/widgets/product/product_item.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.productItem,
  });

  final ProductItem productItem;

  @override
  ConsumerState<ProductDetailScreen> createState() {
    return _ProductDetailState();
  }
}

class _ProductDetailState extends ConsumerState<ProductDetailScreen> {
  final ApiProduct _apiProduct = ApiProduct();

  

  void _selectProduct(BuildContext context, ProductItem productItem) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(productItem: productItem),
      ),
    );
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      ref
          .read(viewedProductsProvider.notifier)
          .toggleProductViewedStatus(widget.productItem.id);
    });

    super.initState();
  }

  Future<List<dynamic>> _getSimilarProducts(String category) async {
    try {
      final response = await _apiProduct.getProducts(0, '', {}, category, 0);
      final products = response['products'] as List<dynamic>;
      products.removeWhere((element) =>
          element['_id'].toString().trim() == widget.productItem.id.trim());
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
  Widget build(BuildContext context) {
    final favoriteProducts = ref.watch(favoriteProductsProvider);
    final isFavorite = favoriteProducts.contains(widget.productItem.id);
    final data = ref.watch(viewedProductsDataProvider);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(
          widget.productItem.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final wasAdded = ref
                  .read(favoriteProductsProvider.notifier)
                  .toggleProductFavoriteStatus(
                    widget.productItem.id,
                  );

              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    wasAdded
                        ? '${widget.productItem.name} is added to favorite list'
                        : '${widget.productItem.name} is removed to favorite list',
                  ),
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                isFavorite
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.surface,
              ),
            ),
            icon: AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 500,
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.onSurface,
                key: ValueKey(isFavorite),
              ),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: Tween<double>(begin: 0.7, end: 1).animate(animation),
                  child: child,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 100,
        width: double.infinity,
        alignment: Alignment.center,
        child: PersistentShoppingCart().showAndUpdateCartItemWidget(
          inCartWidget: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Center(
              child: Text(
                'REMOVE TO CART',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          notInCartWidget: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Center(
              child: Text(
                'ADD TO CART',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          product: PersistentShoppingCartItem(
            productId: widget.productItem.id,
            productName: widget.productItem.name,
            unitPrice: widget.productItem.price,
            quantity: 1,
            productThumbnail: widget.productItem.thumbUrl,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ProductImages(
                productItem: widget.productItem,
              ),
              const SizedBox(
                height: 5,
              ),
              ProductDescription(
                productItem: widget.productItem,
              ),
              const SizedBox(
                height: 18,
              ),
              const Divider(
                color: Colors.grey,
                height: 1,
                thickness: 1,
              ),
              const SizedBox(
                height: 12,
              ),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Similar Products',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Icon(Icons.view_compact_alt_outlined),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  FutureBuilder(
                    future: _getSimilarProducts(widget.productItem.category),
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
                        final similarProduct = snapshot.data;
                        if (similarProduct!.isEmpty) {
                          return const Text(
                            'No similar products ',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          );
                        }
                        return SizedBox(
                          height: 323,
                          child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: similarProduct.length,
                            itemBuilder: (context, index) {
                              final List<String> images = [];
                              for (var image in similarProduct[index]
                                  ['images']) {
                                images.add(image['url']);
                              }
                              final List<Map<String, dynamic>> reviews = [];
                              for (var review in similarProduct[index]
                                  ['reviews']) {
                                reviews.add(
                                  {
                                    'user': review['user'].toString(),
                                    'rating': review['rating'].toInt(),
                                    'comment': review['comment'].toString()
                                  },
                                );
                              }
                              final productItem = ProductItem(
                                id: similarProduct[index]['_id'].toString(),
                                name: similarProduct[index]['name'].toString(),
                                price:
                                    similarProduct[index]['price'].toDouble(),
                                ratings:
                                    similarProduct[index]['ratings'].toDouble(),
                                thumbUrl: similarProduct[index]['images'][0]
                                        ['url']
                                    .toString(),
                                numOfReviews: similarProduct[index]
                                        ['numOfReviews']
                                    .toInt(),
                                stock: similarProduct[index]['stock'].toInt(),
                                description: similarProduct[index]
                                        ['description']
                                    .toString(),
                                seller:
                                    similarProduct[index]['seller'].toString(),
                                category: similarProduct[index]['category']
                                    .toString(),
                                images: images,
                                reviews: reviews,
                              );
                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                ),
                                child: ProductItemWidget(
                                  productItem: productItem,
                                  onSelectProduct: _selectProduct,
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              const Divider(
                color: Colors.grey,
                height: 1,
                thickness: 1,
              ),
              const SizedBox(
                height: 12,
              ),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Viewed Products',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Icon(Icons.visibility_outlined),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
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
                        final viewedProduct = snapshot.data;
                        if (viewedProduct!.isEmpty) {
                          return const Text(
                            'No products have been viewed',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          );
                        }
                        return SizedBox(
                          height: 323,
                          child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: viewedProduct.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                ),
                                child: ProductItemWidget(
                                  productItem: viewedProduct[index],
                                  onSelectProduct: _selectProduct,
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              const Divider(
                color: Colors.grey,
                height: 1,
                thickness: 1,
              ),
              const SizedBox(
                height: 12,
              ),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reviews',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Icon(Icons.reviews),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ProductReviews(productItem: widget.productItem),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
