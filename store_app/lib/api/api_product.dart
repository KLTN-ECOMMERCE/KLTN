import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/utils/constants.dart';

class ApiProduct {
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
        'api/v1/products/',
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
        'api/v1/products/',
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
      'api/v1/products/popular',
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
      'api/v1/products/$productId',
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
}
