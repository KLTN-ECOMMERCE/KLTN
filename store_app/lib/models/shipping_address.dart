import 'package:country_picker/country_picker.dart';
import 'package:store_app/models/place.dart';

class ShippingAddress {
  ShippingAddress({
    required this.address,
    required this.city,
    required this.country,
    required this.phoneNo,
    required this.zipCode,
    required this.place,
    required this.isDefault,
    this.id,
  });
  final String address, city, phoneNo, zipCode;
  final Country country;
  final Place place;
  final bool isDefault;
  String? id;
}
