enum Categories {
  electronics,
  cameras,
  laptops,
  accessories,
  headphones,
  tablets,
  smartwatchs,
  phones,
  popular,
}

class Category {
  const Category({
    required this.title,
    required this.image,
  });
  final String title;
  final String image;
}
