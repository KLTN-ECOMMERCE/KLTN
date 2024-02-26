import 'package:flutter/material.dart';
import 'package:store_app/models/product_item.dart';
import 'package:store_app/widgets/home/section_title.dart';
import 'package:store_app/widgets/product/product_item.dart';

class ListProductHor extends StatelessWidget {
  const ListProductHor({
    super.key,
    required this.sectionTitle,
    required this.products,
    required this.onSelectProduct,
  });

  final String sectionTitle;
  final List<dynamic> products;

  final void Function(BuildContext context, ProductItem productItem)
      onSelectProduct;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: sectionTitle,
            press: () {},
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 20,),
                child: ProductItemWidget(
                  productItem: ProductItem(
                    id: products[index]['_id'].toString(),
                    name: products[index]['name'].toString(),
                    price: products[index]['price'].toDouble(),
                    ratings: products[index]['ratings'].toDouble(),
                    thumbUrl:
                        products[index]['images'][0]['url'].toString(),
                    numOfReviews: products[index]['numOfReviews'].toInt(),
                    stock: products[index]['stock'].toInt(),
                  ),
                  onSelectProduct: onSelectProduct,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
