import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:store_app/utils/constants.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ApiVoucher {
  final storage = const FlutterSecureStorage();
  Future<dynamic> getAllVoucher() async {
    final url = Uri.https(
      host,
      'api/v1/mobile/voucher/getAllVoucher',
    );
    print(url);
    try {
      Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode != 200) {
        throw const HttpException('Failed to load promotions');
      }
      return resData['voucher'];
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> getVoucherById(String id) async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.https(
      host,
      'api/v1/mobile/voucher/getVoucherbyId/$id',
    );
    print(url);
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
        throw const HttpException('Failed to load promotions');
      }
      return resData['voucher'];
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> userAddVoucher(String id) async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.https(
      host,
      'api/v1/mobile/voucher/addVoucher/$id',
    );
    print(url);
    try {
      Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode == 400) {
        final message = resData['message'] as String;
        throw HttpException(message);
      }
      if (response.statusCode != 200) {
        throw const HttpException('Failed to add voucher');
      }
      return resData['success'];
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
  
  Future<dynamic> userUseVoucher(String id) async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.https(
      host,
      'api/v1/mobile/voucher/useVoucher/$id',
    );
    print(url);
    try {
      Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode == 400) {
        final message = resData['message'] as String;
        throw HttpException(message);
      }
      if (response.statusCode != 200) {
        throw const HttpException('Failed to use voucher');
      }
      return resData['success'];
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
}
