import 'package:flutter/material.dart';

enum Categories {
  electronics,
  cameras,
  laptops,
  accessories,
  headphones,
  food,
  books,
  sports,
  outdoor,
  home,
}

class Category {
  const Category({
    required this.title,
    required this.color,
  });
  final String title;
  final Color color;
}
