import 'package:flutter/material.dart';
import 'package:store_app/models/category.dart';

const categories = {
  Categories.accessories: Category(
    title: 'Accessories',
    color: Color.fromARGB(255, 0, 255, 128),
  ),
  Categories.books: Category(
    title: 'Books',
    color: Color.fromARGB(255, 145, 255, 0),
  ),
  Categories.cameras: Category(
    title: 'Cameras',
    color: Color.fromARGB(255, 255, 102, 0),
  ),
  Categories.electronics: Category(
    title: 'Electronics',
    color: Color.fromARGB(255, 0, 208, 255),
  ),
  Categories.food: Category(
    title: 'Food',
    color: Color.fromARGB(255, 0, 60, 255),
  ),
  Categories.headphones: Category(
    title: 'Headphones',
    color: Color.fromARGB(255, 255, 149, 0),
  ),
  Categories.home: Category(
    title: 'Home',
    color: Color.fromARGB(255, 255, 187, 0),
  ),
  Categories.laptops: Category(
    title: 'Laptops',
    color: Color.fromARGB(255, 191, 0, 255),
  ),
  Categories.outdoor: Category(
    title: 'Outdoor',
    color: Color.fromARGB(255, 149, 0, 225),
  ),
  Categories.sports: Category(
    title: 'Sports',
    color: Color.fromARGB(255, 0, 255, 255),
  ),
};
