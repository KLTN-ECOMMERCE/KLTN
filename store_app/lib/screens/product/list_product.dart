import 'package:flutter/material.dart';
import 'package:store_app/models/category.dart';
import 'package:store_app/models/product_item.dart';
import 'package:store_app/screens/filter/filters.dart';
import 'package:store_app/screens/filter/sorts.dart';
import 'package:store_app/screens/product/product_detail.dart';
import 'package:store_app/widgets/category/list_category_hor.dart';
import 'package:store_app/widgets/home/home_header.dart';
import 'package:store_app/widgets/product/list_product_ver.dart';

class ListProductScreen extends StatefulWidget {
  const ListProductScreen({
    super.key,
    required this.products,
    required this.category,
    required this.onGetProductInCategory,
  });

  final List products;
  final Category category;
  final Future<List> Function(String category) onGetProductInCategory;

  @override
  State<ListProductScreen> createState() => _ListProductState();
}

class _ListProductState extends State<ListProductScreen> {
  List _products = [];
  List _filtersProducts = [];
  bool _isFilters = false;
  bool _isSort = false;
  String _title = '';
  bool _changeProduct = false;
  Map<String, RangeValues> _filtersValue = {};

  void _selectProduct(BuildContext context, ProductItem productItem) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(productItem: productItem),
      ),
    );
  }

  void _selectCategory(BuildContext context, Category category) async {
    final products = await widget.onGetProductInCategory(category.title);
    setState(() {
      _title = category.title;
      _changeProduct = true;
      _isFilters = false;
      _filtersProducts = [];
      _products = products;
    });
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
      _filtersProducts = [];
      _filtersValue = data != null ? data as Map<String, RangeValues> : {};
      _isFilters = data != null ? true : false;
      if (_isFilters == true && data != null && _filtersValue.isNotEmpty) {
        final productList = _changeProduct ? _products : widget.products;
        _filtersProducts = productList.where((product) {
          final price = product['price'];
          final ratings = product['ratings'];
          return price >= _filtersValue['rangePriceValue']?.start.toDouble() &&
              price <= _filtersValue['rangePriceValue']?.end.toDouble() &&
              ratings >= _filtersValue['rangeRatingValue']?.start.toDouble() &&
              ratings <= _filtersValue['rangeRatingValue']?.end.toDouble();
        }).toList();
      }
    });
  }

  void _openSortsOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => const SortsScreen(),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: (MediaQuery.of(context).size.height) / 1.4,
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
        title: Text(
          _changeProduct ? _title : widget.category.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 8,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const HomeHeader(),
              const SizedBox(
                height: 18,
              ),
              ListCategoryHor(
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
              ListProductVer(
                products: _isFilters
                    ? _filtersProducts
                    : (_changeProduct ? _products : widget.products),
                onSelectProduct: _selectProduct,
                isLoadingMore: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
