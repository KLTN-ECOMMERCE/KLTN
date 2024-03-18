class DeliveryMethod {
  const DeliveryMethod({
    required this.name,
    required this.image,
    required this.duration,
    required this.price,
  });
  final String name, image, duration;
  final double price;
}
