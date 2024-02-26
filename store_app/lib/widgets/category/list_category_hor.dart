import 'package:flutter/material.dart';
import 'package:store_app/data/categories.dart';
import 'package:store_app/models/category.dart';
import 'package:store_app/widgets/category/category_item.dart';
import 'package:store_app/widgets/home/section_title.dart';

class ListCategoryHor extends StatelessWidget {
  const ListCategoryHor({
    super.key,
    required this.sectionTitle,
    required this.onSelectCategory,
  });

  final String sectionTitle;

  final void Function(BuildContext context, Category category)
      onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: sectionTitle,
            press: () {},
          ),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 120,
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CategoryItemWidget(
                      category: categories.entries.elementAt(index).value,
                      onSelectCategory: onSelectCategory,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
