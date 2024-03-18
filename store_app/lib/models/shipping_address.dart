import 'package:country_picker/country_picker.dart';

class ShippingAddress {
  const ShippingAddress({
    required this.fullName,
    required this.address,
    required this.city,
    required this.country,
    required this.phoneNo,
    required this.zipCode,
  });
  final String fullName, address, city, phoneNo, zipCode;
  final Country country;
}
