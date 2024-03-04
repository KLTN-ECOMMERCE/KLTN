import 'package:flutter/material.dart';
import 'package:store_app/models/product_item.dart';
import 'package:store_app/widgets/product/large_product_item.dart';

class ListProductVer extends StatelessWidget {
  const ListProductVer({
    super.key,
    required this.products,
    required this.onSelectProduct,
    required this.isLoadingMore,
  });

  final List products;
  final void Function(BuildContext context, ProductItem productItem)
      onSelectProduct;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
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
            itemCount: isLoadingMore ? products.length + 1 : products.length,
            itemBuilder: (context, index) {
              if (index < products.length) {
                final List<String> images = [];
                for (var image in products[index]['images']) {
                  images.add(image['url']);
                }
                return LargeProductItem(
                  productItem: ProductItem(
                    id: products[index]['_id'].toString(),
                    name: products[index]['name'].toString(),
                    price: products[index]['price'].toDouble(),
                    ratings: products[index]['ratings'].toDouble(),
                    thumbUrl: products[index]['images'][0]['url'].toString(),
                    numOfReviews: products[index]['numOfReviews'].toInt(),
                    stock: products[index]['stock'].toInt(),
                    description: products[index]['description'].toString(),
                    seller: products[index]['seller'].toString(),
                    category: products[index]['category'].toString(),
                    images: images,
                  ),
                  onSelectProduct: onSelectProduct,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
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
