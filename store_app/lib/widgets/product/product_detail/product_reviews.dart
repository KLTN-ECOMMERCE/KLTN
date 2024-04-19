import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:store_app/api/api_user.dart';
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
  final ApiUser _apiUser = ApiUser();

  Future<dynamic> _getUserReviewInfo(String userId) async {
    try {
      final response = await _apiUser.findUser(userId);
      return response;
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
          return FutureBuilder(
            future: _getUserReviewInfo(
              widget.productItem.reviews[index]['user'].toString(),
            ),
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
                final userData = snapshot.data;
                return Stack(
                  fit: StackFit.loose,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 24,
                        left: 12,
                        top: 16,
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
                                userData['name'].toString(),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RatingBar.builder(
                                    ignoreGestures: true,
                                    initialRating: widget
                                        .productItem.reviews[index]['rating']
                                        .toDouble(),
                                    tapOnlyMode: true,
                                    itemSize: 18,
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
                    Positioned(
                      top: 0,
                      left: 0,
                      child: CircleAvatar(
                        backgroundImage: userData['avatar']['url'] == null
                            ? const AssetImage(
                                'assets/images/Profile Image.jpg')
                            : NetworkImage(userData['avatar']['url'].toString())
                                as ImageProvider,
                      ),
                    ),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }
}
