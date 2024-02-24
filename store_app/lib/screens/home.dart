import 'dart:async';
import 'package:flutter/material.dart';
import 'package:store_app/data/categories.dart';
import 'package:store_app/models/product_item.dart';
import 'package:store_app/widgets/category/category_item.dart';
import 'package:store_app/widgets/product/product_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.homeController,
  });

  final ScrollController homeController;

  @override
  State<HomeScreen> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen> {
  List<ProductItem> list = [
    const ProductItem(
      name: 'Apple Iphone 15 Pro Max',
      price: 1200.6473,
      ratings: 4,
      thumbUrl:
          'https://shopdunk.com/images/thumbs/0020079_iphone-15-pro-max-128gb.jpeg',
      numOfReview: 15,
      stock: 200,
    ),
    const ProductItem(
      name: 'Apple Iphone 15 Pro Max',
      price: 1200.6473,
      ratings: 4,
      thumbUrl:
          'https://shopdunk.com/images/thumbs/0020079_iphone-15-pro-max-128gb.jpeg',
      numOfReview: 15,
      stock: 200,
    ),
    const ProductItem(
      name: 'Apple Iphone 15 Pro Max',
      price: 1200.6473,
      ratings: 4,
      thumbUrl:
          'https://shopdunk.com/images/thumbs/0020079_iphone-15-pro-max-128gb.jpeg',
      numOfReview: 15,
      stock: 200,
    ),
    const ProductItem(
      name: 'Apple Iphone 15 Pro Max',
      price: 1200.6473,
      ratings: 4,
      thumbUrl:
          'https://shopdunk.com/images/thumbs/0020079_iphone-15-pro-max-128gb.jpeg',
      numOfReview: 15,
      stock: 200,
    ),
    const ProductItem(
      name: 'Apple Iphone 15 Pro Max',
      price: 1200.6473,
      ratings: 4,
      thumbUrl:
          'https://shopdunk.com/images/thumbs/0020079_iphone-15-pro-max-128gb.jpeg',
      numOfReview: 15,
      stock: 200,
    ),
  ];
  void _selectProductItem(BuildContext context, ProductItem productItem) {}

  void _selectCategoryItem(BuildContext context, String category) {}

  PageController pageController = PageController();
  int pageNo = 0;

  @override
  void initState() {
    pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.88,
    );
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (pageNo == categories.length) {
        pageNo = 0;
      }
      pageController.animateToPage(
        pageNo,
        duration: const Duration(
          seconds: 1,
        ),
        curve: Curves.easeInOutCirc,
      );
      pageNo++;
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('HOME'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        leading: Image.asset(
          'assets/images/logo.png',
        ),
      ),
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: widget.homeController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/banner1.jpg',
                width: double.infinity,
              ),
              SizedBox(
                height: 100,
                child: PageView.builder(
                  itemCount: categories.length,
                  controller: pageController,
                  onPageChanged: (value) {
                    setState(() {
                      pageNo = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: pageController,
                      builder: (context, child) {
                        return child!;
                      },
                      child: CategoryItemWidget(
                        category: categories.entries.elementAt(index).value,
                        onSelectCategory: _selectCategoryItem,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  categories.length,
                  (index) => GestureDetector(
                    onTap: () {
                      //pageNo = index;
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutCirc,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.circle,
                        size: 15,
                        color: pageNo == index
                            ? categories.entries.elementAt(pageNo).value.color
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) => ProductItemWidget(
                  productItem: list[index],
                  onSelectProduct: _selectProductItem,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
