import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:store_app/models/delivery_method.dart';
import 'package:store_app/models/shipping_address.dart';
import 'package:store_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiOrder {
  final storage = const FlutterSecureStorage();
  Future<dynamic> createOrder(
    ShippingAddress shippingInfo,
    List<PersistentShoppingCartItem> orderItems,
    String paymentMethod,
    Map<String, String> paymentInfo,
    double itemsPrice,
    double taxAmount,
    DeliveryMethod deliveryMethod,
    double totalAmount,
  ) async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/orders/new',
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
        'fullName': shippingInfo.fullName,
        'address': shippingInfo.address,
        'city': shippingInfo.city,
        'phoneNo': shippingInfo.phoneNo,
        'zipCode': shippingInfo.zipCode,
        'country': shippingInfo.country.displayNameNoCountryCode,
      },
      'orderItems': products,
      'paymentMethod': paymentMethod,
      'paymentInfo': paymentInfo,
      'itemsPrice': itemsPrice,
      'taxAmount': taxAmount,
      'shippingAmount': deliveryMethod.price,
      'totalAmount': totalAmount,
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
      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode != 200) throw HttpException(resData['message']);
      print(resData);

      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> getOrders() async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/me/orders',
    );
    try {
      Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );
      final dynamic resData = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(resData['message'] as String);
      }
      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> getOrderDetails(String orderId) async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/orders/$orderId',
    );
    try {
      Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(resData['message'] as String);
      }
      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
}
