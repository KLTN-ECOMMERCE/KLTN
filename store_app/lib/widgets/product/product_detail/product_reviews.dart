import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:store_app/models/product_item.dart';

class ProductReviews extends StatefulWidget {
  const ProductReviews({
    super.key,
    required this.productItem,
  });
  final ProductItem productItem;

  @override
  State<ProductReviews> createState() => _ProductReviewsState();
}

class _ProductReviewsState extends State<ProductReviews> {
  String maskString(String input) {
    if (input.length <= 10) {
      return input;
    }
    return '${input.substring(0, 7)}*********${input.substring(input.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.productItem.reviews.isEmpty) {
      return const Center(
        child: Text(
          'No reviews ...',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.only(
        left: 4,
        right: 4,
      ),
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.productItem.reviews.length,
        itemBuilder: (context, index) {
          final maskUser =
              maskString(widget.productItem.reviews[index]['user'].toString());
          return Stack(
            fit: StackFit.loose,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  bottom: 24,
                  left: 18,
                  top: 12,
                ),
                child: Card(
                  color: Theme.of(context).cardColor.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 18,
                      right: 18,
                      top: 12,
                      bottom: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'User: $maskUser',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RatingBar.builder(
                              ignoreGestures: true,
                              initialRating: widget
                                  .productItem.reviews[index]['rating']
                                  .toDouble(),
                              tapOnlyMode: true,
                              itemSize: 16,
                              itemPadding: const EdgeInsets.symmetric(
                                horizontal: 1.5,
                              ),
                              maxRating: 5,
                              minRating: 0.5,
                              allowHalfRating: true,
                              itemCount: 5,
                              direction: Axis.horizontal,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (value) {},
                            ),
                            const Icon(Icons.mark_chat_read_outlined),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          widget.productItem.reviews[index]['comment']
                              .toString(),
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: 0,
                left: 0,
                child: CircleAvatar(       
                  backgroundImage:
                      AssetImage('assets/images/Profile Image.jpg'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
