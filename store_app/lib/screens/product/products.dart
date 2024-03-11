import 'dart:io';

import 'package:flutter/material.dart';
import 'package:store_app/api/api_product.dart';
import 'package:store_app/data/type_of_sort.dart';
import 'package:store_app/models/category.dart';
import 'package:store_app/models/product_item.dart';
import 'package:store_app/screens/filter/filters.dart';
import 'package:store_app/screens/filter/sorts.dart';
import 'package:store_app/screens/product/product_detail.dart';
import 'package:store_app/widgets/category/list_category_hor.dart';
import 'package:store_app/widgets/home/home_header.dart';
import 'package:store_app/widgets/product/list_product_ver.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({
    super.key,
    this.searchKeyword = '',
    this.category = '',
  });

  final String searchKeyword;
  final String category;

  @override
  State<ProductScreen> createState() {
    return _ProductState();
  }
}

class _ProductState extends State<ProductScreen> {
  final ApiProduct _apiProduct = ApiProduct();
  final _scrollController = ScrollController();

  var _currentPage = 1;
  bool _moreProduct = true;
  bool _isSort = false;
  bool _isLoadingMore = false;
  bool _isFilters = false;
  var _sortValue = 0;
  List _products = [];
  Map<String, RangeValues> _filtersValue = {};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getProducts() async {
    try {
      final response = await _apiProduct.getProducts(
        _currentPage,
        widget.searchKeyword,
        _filtersValue,
        widget.category,
        _sortValue,
      );
      final products = response['products'] as List;
      if (products.length < 8) {
        _moreProduct = false;
      }
      setState(() {
        _products = _products + products;
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

  @override
  void initState() {
    _getProducts();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> _scrollListener() async {
    if (_moreProduct) {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _isLoadingMore = true;
        });
        _currentPage = _currentPage + 1;
        await _getProducts();
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  void _selectProduct(BuildContext context, ProductItem productItem) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(productItem: productItem),
      ),
    );
  }

  void _openFiltersOverlay() async {
    final data = await showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => FiltersScreen(
        filtersValue: _filtersValue,
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: (MediaQuery.of(context).size.height) / 1.4,
      ),
    );
    setState(() {
      _filtersValue = data != null ? data as Map<String, RangeValues> : {};

      _products = [];

      _isFilters = data != null ? true : false;
      _currentPage = 1;
      _moreProduct = true;
      _isLoadingMore = false;

      _getProducts();
    });
  }

  void _openSortsOverlay() async {
    final data = await showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => const SortsScreen(),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: (MediaQuery.of(context).size.height) / 1.7,
      ),
    );
    setState(() {
      _isSort = data != null ? true : false;

      _products = [];

      if (data != null) {
        if (data == typeOfSort[0]) {
          _sortValue = 1;
        }
        if (data == typeOfSort[1]) {
          _sortValue = 2;
        }
        if (data == typeOfSort[2]) {
          _sortValue = 3;
        }
        if (data == typeOfSort[3]) {
          _sortValue = 4;
        }
      } else {
        _sortValue = 0;
      }

      _currentPage = 1;
      _moreProduct = true;
      _isLoadingMore = false;

      _getProducts();
    });
  }

  void _selectCategory(BuildContext context, Category category) async {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ProductScreen(
          category: category.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final surface = Theme.of(context).colorScheme.surface;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
        ),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 8,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const HomeHeader(),
              ListCategoryHor(
                sectionTitle: 'Explore now',
                onSelectCategory: _selectCategory,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _openFiltersOverlay,
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Filters'),
                    style: ButtonStyle(
                      elevation: const MaterialStatePropertyAll(0),
                      backgroundColor: _isFilters
                          ? MaterialStatePropertyAll(
                              primary,
                            )
                          : MaterialStatePropertyAll(
                              surface,
                            ),
                      foregroundColor: _isFilters
                          ? MaterialStatePropertyAll(
                              onPrimary,
                            )
                          : MaterialStatePropertyAll(
                              onSurface,
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton.icon(
                    onPressed: _openSortsOverlay,
                    icon: const Icon(Icons.sort),
                    label: const Text('Sorts'),
                    style: ButtonStyle(
                      elevation: const MaterialStatePropertyAll(0),
                      backgroundColor: _isSort
                          ? MaterialStatePropertyAll(
                              primary,
                            )
                          : MaterialStatePropertyAll(
                              surface,
                            ),
                      foregroundColor: _isSort
                          ? MaterialStatePropertyAll(
                              onPrimary,
                            )
                          : MaterialStatePropertyAll(
                              onSurface,
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              if (widget.searchKeyword != '')
                Center(
                  child: Text(
                    'Results of: \'${widget.searchKeyword}\'',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (widget.category != '')
                Center(
                  child: Text(
                    'Results of: \'${widget.category}\'',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
}
