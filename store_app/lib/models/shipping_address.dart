import 'package:country_picker/country_picker.dart';

class ShippingAddress {
  ShippingAddress({
    required this.address,
    required this.city,
    required this.country,
    required this.phoneNo,
    required this.zipCode,
    this.id,
  });
  final String address, city, phoneNo, zipCode;
  final Country country;
  String? id;
}
