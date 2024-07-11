import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shipping_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiShipper {
  final storage = const FlutterSecureStorage();

  Future<dynamic> getOrderByShippingUnit() async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.https(
      host,
      'api/v1/shipping/getOrderByShippingUnit',
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
      if (response.statusCode == 404 &&
          resData['message'].toString() ==
              'No orders found for the given shippingUnit') return [];
      if (response.statusCode != 200) throw HttpException(resData['message']);
      return resData['orders'] as List;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> deliveredSucessfully(String orderId) async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.https(
      host,
      'api/v1/shipper/deliveredSuccess/$orderId',
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
      print(resData);
      if (response.statusCode != 200) throw HttpException(resData['message']);
      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> getShipper() async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.https(
      host,
      'api/v1/shipper',
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
      print(resData);
      if (response.statusCode != 200) throw HttpException(resData['message']);
      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
}
