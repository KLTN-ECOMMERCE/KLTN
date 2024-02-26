import 'package:flutter/material.dart';
import 'package:store_app/constants.dart';
import 'package:store_app/models/product_item.dart';

class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget({
    super.key,
    this.aspectRetio = 1.02,
    this.width = 140,
    required this.productItem,
    required this.onSelectProduct,
  });

  final double width, aspectRetio;
  final ProductItem productItem;
  final void Function(BuildContext context, ProductItem productItem)
      onSelectProduct;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: () {
          onSelectProduct(context, productItem);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.network(
                  productItem.thumbUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              productItem.name,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${productItem.price}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                IconButton.filledTonal(
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(30, 30),
                    fixedSize: const Size(30, 30),
                  ),
                  iconSize: 20,
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
