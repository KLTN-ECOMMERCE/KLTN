class ProductItem {
  const ProductItem({
    required this.name,
    required this.price,
    required this.ratings,
    required this.thumbUrl,
    required this.numOfReview,
    required this.stock,
  });

  final String name;
  final double price;
  final double ratings;
  final String thumbUrl;
  final int numOfReview;
  final int stock;
}
