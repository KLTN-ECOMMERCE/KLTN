import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_app/api/api_product.dart';
import 'package:store_app/models/product_item.dart';
import 'package:store_app/providers/favorites_provider.dart';

final favoriteProductsDataProvider = Provider(
  (ref) async {
    final ApiProduct apiProduct = ApiProduct();
    final listProductsId = ref.watch(favoriteProductsProvider);
    List<ProductItem> favoriteProductsData = [];

    try {
      for (var productId in listProductsId) {
        final List<String> images = [];
        final response = await apiProduct.getProductDetail(productId);
        for (var image in response['images']) {
          images.add(image['url']);
        }
        final List<Map<String, dynamic>> reviews = [];
        for (var review in response['reviews']) {
          reviews.add(
            {
              'user': review['user']['_id'].toString(),
              'rating': review['rating'].toInt(),
              'comment': review['comment'].toString()
            },
          );
        }
        final productItem = ProductItem(
          id: response['_id'].toString(),
          name: response['name'].toString(),
          price: response['price'].toDouble(),
          ratings: response['ratings'].toDouble(),
          thumbUrl: response['images'][0]['url'].toString(),
          numOfReviews: response['numOfReviews'].toInt(),
          stock: response['stock'].toInt(),
          category: response['category'].toString(),
          description: response['description'].toString(),
          images: images,
          seller: response['seller'].toString(),
          reviews: reviews,
        );
        favoriteProductsData.add(productItem);
      }
      return favoriteProductsData;
    } catch (e) {
      throw HttpException(e.toString());
    }
  },
);
