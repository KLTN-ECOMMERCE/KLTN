import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shipping_app/model/login.dart';
import 'package:shipping_app/utils/constants.dart';

class ApiStart {
  final storage = const FlutterSecureStorage();

  Future<Object> login(Login userData) async {
    final url = Uri.https(
      host,
      'api/v1/mobile/login',
    );
    Map<String, String> body = {
      'email': userData.email,
      'password': userData.password,
    };

    try {
      Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (response.statusCode != 200) throw HttpException(resData['message']);

      await storage.deleteAll();

      await storage.write(
        key: 'access-token',
        value: resData['token'],
      );

      await storage.write(
        key: 'email',
        value: userData.email,
      );

      await storage.write(
        key: 'remind',
        value: 'false',
      );

      //final token = await storage.read(key: 'access-token');
      //print(token);

      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> logout() async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.https(
      host,
      'api/v1/mobile/logout',
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
      await storage.deleteAll();
      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
}
