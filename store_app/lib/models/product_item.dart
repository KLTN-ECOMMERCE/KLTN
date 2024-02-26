class ProductItem {
  const ProductItem({
    required this.id,
    required this.name,
    required this.price,
    required this.ratings,
    required this.thumbUrl,
    required this.numOfReviews,
    required this.stock,
  });

  final String id;
  final String name;
  final double price;
  final double ratings;
  final String thumbUrl;
  final int numOfReviews;
  final int stock;
}
