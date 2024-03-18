import 'package:flutter/material.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:store_app/models/product_item.dart';
import 'package:store_app/widgets/product/product_detail/product_description.dart';
import 'package:store_app/widgets/product/product_detail/product_images.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.productItem,
  });

  final ProductItem productItem;

  @override
  State<ProductDetailScreen> createState() {
    return _ProductDetailState();
  }
}

class _ProductDetailState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
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
            onPressed: () {},
            icon: AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 500,
              ),
              child: const Icon(
                Icons.star_border,
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
            ],
          ),
        ),
      ),
    );
  }
}
