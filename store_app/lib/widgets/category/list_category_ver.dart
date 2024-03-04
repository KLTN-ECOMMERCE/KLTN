import 'package:flutter/material.dart';
import 'package:store_app/data/categories.dart';
import 'package:store_app/models/category.dart';
import 'package:store_app/widgets/category/category_item.dart';

class ListCategoryVer extends StatelessWidget {
  const ListCategoryVer({
    super.key,
    required this.onSelectCategory,
  });

  final void Function(BuildContext context, Category category) onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 20,
        top: 20,
        right: 18,
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryItemWidget(
            category: categories.entries.elementAt(index).value,
            onSelectCategory: onSelectCategory,
          );
        },
      ),
    );
  }
}
