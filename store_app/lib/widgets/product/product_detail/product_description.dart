import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_app/models/product_item.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    super.key,
    required this.productItem,
  });

  final ProductItem productItem;

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${widget.productItem.stock} products',
                style: const TextStyle(
                  fontSize: 13,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.grey,
          height: 1,
          thickness: 1,
        ),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              widget.productItem.name,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Theme.of(context).colorScheme.surface,
          ),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    '${widget.productItem.price}\$',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  RatingBar.builder(
                    ignoreGestures: true,
                    initialRating: widget.productItem.ratings,
                    tapOnlyMode: true,
                    itemSize: 21,
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
                  Text(
                    '(${widget.productItem.ratings} / 5.0)',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // const SizedBox(
        //   height: 16,
        // ),
        // Container(
        //   padding: const EdgeInsets.all(16),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(25),
        //     color: Theme.of(context).colorScheme.surface,
        //   ),
        //   width: double.infinity,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Row(
        //         children: [
        //           Text(
        //             'Quantity',
        //             style: TextStyle(
        //               color: Theme.of(context).colorScheme.onSurface,
        //               fontWeight: FontWeight.bold,
        //               fontSize: 23,
        //             ),
        //           ),
        //         ],
        //       ),
        //       Row(
        //         children: [
        //           IconButton(
        //             iconSize: 28,
        //             onPressed: () {
        //               if (_quantity == 1) {
        //                 setState(() {
        //                   _quantity;
        //                 });
        //               }
        //               if (_quantity > 1) {
        //                 setState(() {
        //                   _quantity--;
        //                 });
        //               }
        //             },
        //             icon: const Icon(Icons.remove),
        //           ),
        //           const SizedBox(
        //             width: 8,
        //           ),
        //           Text(
        //             '$_quantity',
        //             style: TextStyle(
        //               fontSize: 18,
        //               color: Theme.of(context).colorScheme.onSurface,
        //             ),
        //           ),
        //           const SizedBox(
        //             width: 8,
        //           ),
        //           IconButton(
        //             iconSize: 28,
        //             onPressed: () {
        //               setState(() {
        //                 _quantity++;
        //               });
        //             },
        //             icon: const Icon(Icons.add),
        //           ),
        //           const SizedBox(
        //             width: 8,
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${widget.productItem.numOfReviews} reviews',
                style: const TextStyle(
                  fontSize: 13,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.grey,
          height: 1,
          thickness: 1,
        ),
        const SizedBox(
          height: 8,
        ),
        const Center(
          child: Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Theme.of(context).colorScheme.surface,
          ),
          width: double.infinity,
          child: Text(
            widget.productItem.description.toString().trim(),
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
