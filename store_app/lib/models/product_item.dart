class ProductItem {
  ProductItem({
    required this.id,
    required this.name,
    required this.price,
    required this.ratings,
    required this.thumbUrl,
    required this.numOfReviews,
    required this.stock,
    required this.category,
    required this.description,
    required this.images,
    required this.seller,
    required this.reviews,
    this.sold,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final double ratings;
  final String thumbUrl;
  final List<String> images;
  final String category;
  final String seller;
  final int numOfReviews;
  final int stock;
  final List<Map<String, dynamic>> reviews;
  final int? sold;
}
