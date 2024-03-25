import 'dart:io';

import 'package:flutter/material.dart';
import 'package:store_app/api/api_product.dart';
import 'package:store_app/helper/keyboard.dart';
import 'package:store_app/models/product_item.dart';
import 'package:store_app/screens/product/product_detail.dart';
import 'package:store_app/utils/constants.dart';
import 'package:store_app/screens/product/products.dart';
import 'package:store_app/widgets/product/list_product_ver.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() {
    return _SearchState();
  }
}

const searchOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);

class _SearchState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiProduct _apiProduct = ApiProduct();
  final _scrollController = ScrollController();
  var _currentPage = 1;
  var _sort = 0;
  var _query = '';
  var _category = '';
  bool _moreProduct = true;
  bool _isLoadingMore = false;
  List _products = [];
  Map<String, RangeValues> _filtersValue = {};

  static List previousSearchs = [];
  static List suggestSearchs = [
    'Iphone',
    'TV',
    'Airpod',
    'Apple',
    'Gaming',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _selectProduct(BuildContext context, ProductItem productItem) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(productItem: productItem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Finding',
        ),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: TextFormField(
                          autofocus: true,
                          controller: _searchController,
                          onFieldSubmitted: (value) {
                            if (value.isNotEmpty) {
                              if (!previousSearchs.contains(value.trim())) {
                                previousSearchs.add(value.trim());
                              } else {
                                previousSearchs.remove(value);
                                previousSearchs.add(value.trim());
                              }
                            }
                            FocusScope.of(context).requestFocus(FocusNode());
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ProductScreen(
                                    searchKeyword: value,
                                  );
                                },
                              ),
                            );
                          },
                          onTapOutside: (event) {
                            KeyboardUtil.hideKeyboard(context);
                          },
                          onChanged: (value) {
                            if (value == '') {
                              setState(() {
                                _products = [];
                              });
                            } else {
                              _query = value;
                              searchProduct();
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: kSecondaryColor.withOpacity(0.1),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            border: searchOutlineInputBorder,
                            focusedBorder: searchOutlineInputBorder,
                            enabledBorder: searchOutlineInputBorder,
                            hintText: "Search product",
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchController.text.isEmpty
                                ? null
                                : IconButton(
                                    icon: const Icon(
                                      Icons.cancel,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                      });
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (previousSearchs.isNotEmpty)
                SingleChildScrollView(
                  child: SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: previousSearchs.length,
                      itemBuilder: (context, index) => previousSearchsItem(
                        previousSearchs.length - index - 1,
                      ),
                    ),
                  ),
                ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Suggestions',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        searchSuggestionsTiem(
                          suggestSearchs[0],
                        ),
                        searchSuggestionsTiem(
                          suggestSearchs[1],
                        ),
                        searchSuggestionsTiem(
                          suggestSearchs[2],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        searchSuggestionsTiem(
                          suggestSearchs[3],
                        ),
                        searchSuggestionsTiem(
                          suggestSearchs[4],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_products.isNotEmpty)
                ListProductVer(
                  products: _products,
                  onSelectProduct: _selectProduct,
                  isLoadingMore: _isLoadingMore,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> searchProduct() async {
    try {
      final response = await _apiProduct.getProducts(
        _currentPage,
        _query,
        _filtersValue,
        _category,
        _sort,
      );
      final products = response['products'] as List;
      if (products.length < 8) {
        _moreProduct = false;
      }
      setState(() {
        _products = products;
      });
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

  Future<void> _scrollListener() async {
    KeyboardUtil.hideKeyboard(context);
    if (_moreProduct) {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _isLoadingMore = true;
        });
        _currentPage = _currentPage + 1;

        await searchProduct();
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  searchSuggestionsTiem(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _searchController.text = text;
          });
        },
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  previousSearchsItem(int index) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _searchController.text = previousSearchs[index];
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(
            8,
          ),
          child: Dismissible(
            key: GlobalKey(),
            onDismissed: (DismissDirection dir) {
              setState(() {});
              previousSearchs.removeAt(index);
            },
            child: Row(
              children: [
                const Icon(
                  Icons.av_timer_sharp,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  previousSearchs[index],
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.call_made_outlined,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
