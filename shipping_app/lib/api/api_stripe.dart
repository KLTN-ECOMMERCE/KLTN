import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shipping_app/utils/constants.dart';

class ApiStripe {
  final storage = const FlutterSecureStorage();
  Future<dynamic> createStripeCheckoutSessionShipper(
    double totalAmount,
  ) async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.https(
      host,
      'api/v1/shipper/payment/checkout_session',
    );

    Map<String, dynamic> body = {
      'totalPriceCOD': totalAmount,
      'orderItems': [
        {
          'name': 'Total COD Amount',
        },
      ],
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
