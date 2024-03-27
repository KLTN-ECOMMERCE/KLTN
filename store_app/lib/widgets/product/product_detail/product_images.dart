import 'package:flutter/material.dart';
import 'package:store_app/models/product_item.dart';
import 'package:store_app/widgets/product/product_detail/small_product_images.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    super.key,
    required this.productItem,
  });

  final ProductItem productItem;

  @override
  State<ProductImages> createState() {
    return _ProductImagesState();
  }
}

class _ProductImagesState extends State<ProductImages> {
  int _selectedImage = 0;
  final ScrollController _controller = ScrollController();

  void _animateList(double value) {
    final currentPosition = _controller.offset;
    final newPosition = currentPosition + value;
    _controller.animateTo(
      newPosition,
      duration: const Duration(
        milliseconds: 200,
      ),
      curve: Curves.easeInOutCirc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 20,
        // right: 18,
        // left: 18,
      ),
      padding: const EdgeInsets.only(
        top: 16,
        bottom: 4,
        // right: 16,
        // left: 16,
      ),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  widget.productItem.images[_selectedImage],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                  ),
                  onPressed: () {
                    if (_selectedImage == 0) {
                    } else {
                      setState(() {
                        _selectedImage--;
                      });
                    }
                    _animateList(-(MediaQuery.of(context).size.width / 7));
                  },
                ),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: Center(
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        controller: _controller,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.productItem.images.length,
                        itemBuilder: (context, index) {
                          return SmallProductImage(
                            isSelected: index == _selectedImage,
                            press: () {
                              setState(() {
                                _selectedImage = index;
                              });
                            },
                            image: widget.productItem.images[index],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                  ),
                  onPressed: () {
                    if (_selectedImage ==
                        widget.productItem.images.length - 1) {
                    } else {
                      setState(() {
                        _selectedImage++;
                      });
                    }
                    _animateList(MediaQuery.of(context).size.width / 7);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
