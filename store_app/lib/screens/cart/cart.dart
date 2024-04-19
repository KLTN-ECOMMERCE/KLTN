import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:store_app/api/api_product.dart';
import 'package:store_app/models/product_item.dart';
import 'package:store_app/screens/app.dart';
import 'package:store_app/screens/order/order.dart';
import 'package:store_app/screens/product/product_detail.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ApiProduct _apiProduct = ApiProduct();
  final List<String> _listProductId = [];

  void _selectProduct(BuildContext context, ProductItem productItem) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(productItem: productItem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Column(
          children: [
            Text(
              'Your Cart',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PersistentShoppingCart().showCartItems(
                cartTileWidget: ({required data}) {
                  _listProductId.add(data.productId);
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Column(
                      children: [
                        Card(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          margin: const EdgeInsets.only(
                            bottom: 8,
                            top: 8,
                            right: 4,
                            left: 4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () async {
                              try {
                                final List<String> images = [];
                                final response = await _apiProduct
                                    .getProductDetail(data.productId);
                                for (var image in response['images']) {
                                  images.add(image['url']);
                                }
                                final List<Map<String, dynamic>> reviews = [];
                                for (var review in response['reviews']) {
                                  reviews.add(
                                    {
                                      'user': review['user']['_id'].toString(),
                                      'rating': review['rating'].toInt(),
                                      'comment': review['comment'].toString()
                                    },
                                  );
                                }
                                final productItem = ProductItem(
                                  id: response['_id'].toString(),
                                  name: response['name'].toString(),
                                  price: response['price'].toDouble(),
                                  ratings: response['ratings'].toDouble(),
                                  thumbUrl:
                                      response['images'][0]['url'].toString(),
                                  numOfReviews:
                                      response['numOfReviews'].toInt(),
                                  stock: response['stock'].toInt(),
                                  category: response['category'].toString(),
                                  description:
                                      response['description'].toString(),
                                  images: images,
                                  seller: response['seller'].toString(),
                                  reviews: reviews,
                                );
                                if (!mounted) return;
                                _selectProduct(context, productItem);
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                    ),
                                  );
                                }
                                throw HttpException(e.toString());
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Image.network(
                                    data.productThumbnail!,
                                    fit: BoxFit.fitHeight,
                                    height: 150,
                                    width: 150,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.productName,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/Cash.svg',
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  '${data.unitPrice}\$',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    PersistentShoppingCart()
                                                        .decrementCartItemQuantity(
                                                      data.productId,
                                                    );
                                                  },
                                                  icon:
                                                      const Icon(Icons.remove),
                                                ),
                                                Text(data.quantity.toString()),
                                                IconButton(
                                                  onPressed: () {
                                                    PersistentShoppingCart()
                                                        .incrementCartItemQuantity(
                                                      data.productId,
                                                    );
                                                  },
                                                  icon: const Icon(Icons.add),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Total: ${data.unitPrice * data.quantity}\$',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                PersistentShoppingCart()
                                                    .removeFromCart(
                                                  data.productId,
                                                );
                                              },
                                              icon: const Icon(Icons.delete),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                showEmptyCartMsgWidget: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'No products in cart ...',
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
                ),
              ),
            ),
            PersistentShoppingCart().showTotalAmountWidget(
              cartTotalAmountWidgetBuilder: (totalAmount) => Visibility(
                visible: totalAmount == 0 ? false : true,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  height: 120,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(
                          bottom: 2,
                          top: 8,
                          right: 8,
                          left: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total amount: ',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '$totalAmount\$',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.all(4),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Map<String, dynamic> cartData =
                                PersistentShoppingCart().getCartData();
                            List<PersistentShoppingCartItem> cartItems =
                                cartData['cartItems'];
                            double totalPriceFromData = cartData['totalPrice'];
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => OrderScreen(
                                  cartItems: cartItems,
                                  totalPrice: totalPriceFromData,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                          ),
                          child: const Text('CHECK OUT'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
