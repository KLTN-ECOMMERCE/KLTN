import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ApiProduct {
  Future<dynamic> getProducts(int page) async {
    var pageString = page.toString();
    final url = Uri.http(
      '192.168.0.110:4000',
      'api/v1/products/',
      {
        'page': pageString,
      },
    );

    try {
      Response response = await http.get(
        url,
      );
      //print(response.body);

      final Map<String, dynamic> resData = json.decode(response.body);

      if (response.statusCode != 200) {
        throw const HttpException('Failed to load products');
      }

      //print(resData);
      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
}
