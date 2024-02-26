// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:store_app/api/api_product.dart';
// import 'package:store_app/data/categories.dart';
// import 'package:store_app/models/product_item.dart';
// import 'package:store_app/widgets/category/category_item.dart';
// import 'package:store_app/widgets/product/product_item.dart';

// class HomeScreen1 extends StatefulWidget {
//   const HomeScreen1({
//     super.key,
//     required this.homeController,
//   });

//   final ScrollController homeController;

//   @override
//   State<HomeScreen1> createState() {
//     return _HomeState();
//   }
// }

// class _HomeState extends State<HomeScreen1> {
//   var _isLoading = false;
//   dynamic _responseGetProduct;
//   var _filteredProductsCount = 0;
//   var _resPerPage = 0;
//   dynamic _products;

//   final ApiProduct _apiProduct = ApiProduct();

//   final ScrollController _scrollController = ScrollController();
//   PageController pageController = PageController();
//   RefreshController _refreshController =
//       RefreshController(initialRefresh: false);
//   int pageNo = 0;

//   var currentPage = 0;

//   void _getProducts() async {
//     try {
//       setState(() {
//         _isLoading = true;
//       });
//       final response = await _apiProduct.getProducts(currentPage);
//       _responseGetProduct = response;
//       _filteredProductsCount = _responseGetProduct['filteredProductsCount'];

//       _resPerPage = _responseGetProduct['resPerPage'];
//       _products = _responseGetProduct['products'] as List<dynamic>;
//       if (_products == null) throw const HttpException('No Product');
//       setState(() {
//         _isLoading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).clearSnackBars();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(e.toString()),
//         ),
//       );
//     }
//   }

//   void _selectProductItem(BuildContext context, ProductItem productItem) {}

//   void _selectCategoryItem(BuildContext context, String category) {}

//   @override
//   void initState() {
//     _getProducts();
//     pageController = PageController(
//       initialPage: 0,
//       viewportFraction: 0.88,
//     );
//     Timer.periodic(const Duration(seconds: 3), (timer) {
//       if (pageNo == categories.length) {
//         pageNo = 0;
//       }
//       pageController.animateToPage(
//         pageNo,
//         duration: const Duration(
//           seconds: 1,
//         ),
//         curve: Curves.easeInOutCirc,
//       );
//       pageNo++;
//     });

//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         _lazyLoading();
//       }
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     pageController.dispose();
//     _scrollController.removeListener(() {});
//     _scrollController.dispose();
//     _refreshController.dispose();
//     super.dispose();
//   }

//   void _lazyLoading() async {
//     if (!_isLoading) {
//       setState(() {
//         _isLoading = true;
//         currentPage++;
//       });
//       _getProducts();
//     }
//   }

//   void _onRefresh() async {
//     await Future.delayed(const Duration(milliseconds: 1000));

//     _refreshController.refreshCompleted();
//   }

//   void _onLoading() async {
//     await Future.delayed(const Duration(milliseconds: 1000));

//     if (!mounted) return;
//     try {
//       setState(() {
//         currentPage++;
//       });
//       final response = await _apiProduct.getProducts(currentPage);
//       dynamic data = response;
//       dynamic moreProduct = data['products'] as List<dynamic>;
//       _products.add(moreProduct);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).clearSnackBars();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(e.toString()),
//         ),
//       );
//     }

//     _refreshController.loadComplete();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('HOME'),
//         backgroundColor: theme.colorScheme.primary,
//         foregroundColor: theme.colorScheme.onPrimary,
//         leading: Image.asset(
//           'assets/images/logo.png',
//         ),
//       ),
//       backgroundColor: theme.colorScheme.background,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           controller: widget.homeController,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Image.asset(
//                 'assets/images/banner1.jpg',
//                 width: double.infinity,
//               ),
//               SizedBox(
//                 height: 100,
//                 child: PageView.builder(
//                   itemCount: categories.length,
//                   controller: pageController,
//                   onPageChanged: (value) {
//                     setState(() {
//                       pageNo = value;
//                     });
//                   },
//                   itemBuilder: (context, index) {
//                     return AnimatedBuilder(
//                       animation: pageController,
//                       builder: (context, child) {
//                         return child!;
//                       },
//                       child: CategoryItemWidget(
//                         category: categories.entries.elementAt(index).value,
//                         onSelectCategory: _selectCategoryItem,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(
//                   categories.length,
//                   (index) => GestureDetector(
//                     onTap: () {
//                       pageController.animateToPage(
//                         index,
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeInOutCirc,
//                       );
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.all(2.0),
//                       child: Icon(
//                         Icons.circle,
//                         size: 15,
//                         color: pageNo == index
//                             ? categories.entries.elementAt(pageNo).value.color
//                             : Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Expanded(
//                 child: SmartRefresher(
//                   enablePullDown: true,
//                   enablePullUp: true,
//                   header: WaterDropHeader(),
//                   footer: ClassicFooter(),
//                   controller: _refreshController,
//                   onRefresh: _onRefresh,
//                   onLoading: _onLoading,
//                   child: ListView.builder(
//                     controller: _scrollController,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: _products == null ? 0 : _products.length,
//                     itemBuilder: (context, index) {
//                       return ProductItemWidget(
//                         productItem: ProductItem(
//                           id: _products[index]['_id'],
//                           name: _products[index]['name'],
//                           price: _products[index]['price'].toDouble(),
//                           ratings: _products[index]['ratings'].toDouble(),
//                           thumbUrl: _products[index]['images'][0]['url'],
//                           numOfReviews: _products[index]['numOfReviews'],
//                           stock: _products[index]['stock'],
//                         ),
//                         onSelectProduct: _selectProductItem,
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
