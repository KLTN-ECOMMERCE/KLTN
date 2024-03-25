import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/models/product_item.dart';
import 'package:store_app/providers/favorites_provider.dart';

class LargeProductItem extends ConsumerWidget {
  const LargeProductItem({
    super.key,
    required this.productItem,
    required this.onSelectProduct,
  });

  final ProductItem productItem;
  final void Function(BuildContext context, ProductItem productItem)
      onSelectProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteProducts = ref.watch(favoriteProductsProvider);
    final isFavorite = favoriteProducts.contains(productItem.id);

    final onPrimaryContainerColor =
        Theme.of(context).colorScheme.onPrimaryContainer;
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      margin: const EdgeInsets.only(
        bottom: 12,
        top: 12,
        left: 8,
        right: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          onSelectProduct(context, productItem);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                productItem.thumbUrl,
                fit: BoxFit.fitHeight,
                height: 165,
                width: 150,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productItem.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: onPrimaryContainerColor,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${productItem.stock} products',
                          style: TextStyle(
                            fontSize: 10,
                            color: onPrimaryContainerColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        RatingBar.builder(
                          ignoreGestures: true,
                          initialRating: productItem.ratings,
                          tapOnlyMode: true,
                          itemSize: 18,
                          minRating: 0.5,
                          maxRating: 5,
                          allowHalfRating: true,
                          itemCount: 5,
                          direction: Axis.horizontal,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (value) {},
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '(${productItem.ratings})',
                          style: TextStyle(
                            color: onPrimaryContainerColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      '${productItem.numOfReviews} reviews',
                      style: TextStyle(
                        fontSize: 12,
                        color: onPrimaryContainerColor,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      '${productItem.price.toStringAsFixed(1)}\$',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: onPrimaryContainerColor,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton.filledTonal(
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(30, 30),
                            fixedSize: const Size(30, 30),
                          ),
                          iconSize: 20,
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
                            transitionBuilder: (child, animation) {
                              return RotationTransition(
                                turns: Tween<double>(begin: 0.7, end: 1)
                                    .animate(animation),
                                child: child,
                              );
                            },
                          ),
                          onPressed: () {
                            final wasAdded = ref
                                .read(favoriteProductsProvider.notifier)
                                .toggleProductFavoriteStatus(
                                  productItem.id,
                                );

                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  wasAdded
                                      ? '${productItem.name} is added to favorite list'
                                      : '${productItem.name} is removed to favorite list',
                                ),
                              ),
                            );
                          },
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
    );
  }
}
