import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:store_app/models/shipping_address.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:store_app/models/shipping_unit.dart';
import 'package:store_app/utils/constants.dart';

class ApiStripe {
  final storage = const FlutterSecureStorage();
  Future<dynamic> createStripeCheckoutSession(
    ShippingAddress shippingInfo,
    List<PersistentShoppingCartItem> orderItems,
    double itemsPrice,
    double taxAmount,
    ShippingUnit deliveryMethod,
    double totalAmount,
    int shippingAmount,
    dynamic voucher,
  ) async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.https(
      host,
      'api/v1/payment/checkout_session/mobile',
    );
    final List<Map<String, dynamic>> products = [];
    for (final orderItem in orderItems) {
      products.add(
        {
          'product': orderItem.productId,
          'name': orderItem.productName,
          'quantity': orderItem.quantity,
          'image': orderItem.productThumbnail,
          'price': orderItem.totalPrice,
        },
      );
    }
    Map<String, dynamic> body = {
      'shippingInfo': {
        'address': shippingInfo.address,
        'city': shippingInfo.city,
        'phoneNo': shippingInfo.phoneNo,
        'zipCode': shippingInfo.zipCode,  
        'country': shippingInfo.country.displayNameNoCountryCode,
        //'shippingAmount': deliveryMethod.price,
        'shipping': {
          'shippingUnit': deliveryMethod.id,
          'code': deliveryMethod.code,
        },
        'latitude': shippingInfo.place.latitude.toString(),
        'longitude': shippingInfo.place.longitude.toString(),
      },
      'orderItems': products,
      'itemsPrice': itemsPrice,
      'taxAmount': taxAmount,
      'shippingAmount': shippingAmount,
      'totalAmount': totalAmount,
      'voucherInfo': {
        'voucherId':
            voucher != null ? voucher['id'] : 'abcabcabcabcabcabcabcabc',
        'name': voucher != null ? voucher['name'] : 'null',
        'deliveryFee': voucher != null ? voucher['deliveryFee'] : false,
        'discount': voucher != null ? voucher['discount'] : 0,
      },
    };

    try {
      Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body),
      );

      final resData = json.decode(response.body);
      if (response.statusCode != 200) throw HttpException(resData['message']);

      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
}
