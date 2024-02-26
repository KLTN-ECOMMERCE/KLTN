
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
    required this.image,
  });
  final String title;
  final String image;
}
