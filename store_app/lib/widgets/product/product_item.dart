import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/providers/favorites_provider.dart';
import 'package:store_app/utils/constants.dart';
import 'package:store_app/models/product_item.dart';

class ProductItemWidget extends ConsumerWidget {
  const ProductItemWidget({
    super.key,
    this.aspectRetio = 1.02,
    this.width = 160,
    required this.productItem,
    required this.onSelectProduct,
  });

  final double width, aspectRetio;
  final ProductItem productItem;
  final void Function(BuildContext context, ProductItem productItem)
      onSelectProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteProducts = ref.watch(favoriteProductsProvider);
    final isFavorite = favoriteProducts.contains(productItem.id);
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          onSelectProduct(context, productItem);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 0.85,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.network(
                  productItem.thumbUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 4,
                left: 8,
                right: 8,
                bottom: 2,
              ),
              height: 75,
              child: Text(
                productItem.name,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 4,
                left: 8,
                right: 8,
                bottom: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${productItem.price}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.redAccent,
                    ),
                  ),
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
                        isFavorite ? Icons.favorite : Icons.favorite_border,
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
            ),
          ],
        ),
      ),
    );
  }
}
