import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/utils/constants.dart';

class ApiProduct {
  final storage = const FlutterSecureStorage();
  Future<dynamic> getProducts(
    int page,
    String keyword,
    Map<String, RangeValues>? filters,
    String category,
    int sort,
  ) async {
    var pageString = page.toString();
    var sortString = sort.toString();
    Uri url;
    if (filters!.isEmpty) {
      url = Uri.http(
        '$ipv4Address:4000',
        'api/v1/mobile/products/',
        {
          'page': pageString,
          'keyword': keyword,
          'category': category,
          'sort': sortString,
        },
      );
      print(url);
    } else {
      url = Uri.http(
        '$ipv4Address:4000',
        'api/v1/mobile/products/',
        {
          'page': pageString,
          'keyword': keyword,
          'category': category,
          'sort': sortString,
          'price[gte]': filters['rangePriceValue']?.start.round().toString(),
          'price[lte]': filters['rangePriceValue']?.end.round().toString(),
          'ratings[gte]': filters['rangeRatingValue']?.start.toString(),
          'ratings[lte]': filters['rangeRatingValue']?.end.toString(),
        },
      );
      print(url);
    }

    try {
      Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
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

  Future<dynamic> getPopularProducts() async {
    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/mobile/products/popular',
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
        throw const HttpException('Failed to load products');
      }
      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> getProductDetail(String productId) async {
    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/mobile/products/$productId',
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
        throw const HttpException('Failed to load products');
      }
      return resData['product'];
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> canUserReview(String productId) async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/mobile/can_review',
      {
        'productId': productId,
      },
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
      print(resData);
      if (response.statusCode != 200) {
        throw const HttpException('Failed to load resource');
      }
      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> reviewProduct(
    String productId,
    String comment,
    double rating,
  ) async {
    final jwtToken = await storage.read(key: 'access-token');
    final url = Uri.http(
      '$ipv4Address:4000',
      'api/v1/mobile/reviews',
    );
    print(url);

    Map<String, dynamic> body = {
      'rating': rating.toInt(),
      'comment': comment,
      'productId': productId,
    };

    try {
      Response response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body),
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      print(resData);
      if (response.statusCode != 200) {
        throw const HttpException('Failed to review product');
      }
      return resData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
}
