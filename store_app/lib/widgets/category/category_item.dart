import 'package:flutter/material.dart';
import 'package:store_app/models/category.dart';

class CategoryItemWidget extends StatelessWidget {
  const CategoryItemWidget({
    super.key,
    required this.category,
    required this.onSelectCategory,
  });

  final Category? category;
  final void Function(BuildContext context, String category) onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Theme.of(context).colorScheme.primaryContainer,
      margin: const EdgeInsets.only(
        right: 8,
        left: 8,
        top: 24,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: category!.color,
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          onSelectCategory(context, 'category');
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              category!.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
