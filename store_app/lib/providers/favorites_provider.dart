import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteProductsNotifier extends StateNotifier<List<String>> {
  // init value state = values.toList() in box
  FavoriteProductsNotifier()
      : super(
          Hive.box<String>('favorite_products').values.toList(),
        );

  bool toggleProductFavoriteStatus(String productId) {
    final box = Hive.box<String>('favorite_products');
    final productIsFavorite = box.values.contains(productId);

    if (productIsFavorite) {
      box.delete(productId);
      state = box.values.toList();
      return false;
    } else {
      box.put(productId, productId);
      state = box.values.toList();
      return true;
    }
  }
}

final favoriteProductsProvider =
    StateNotifierProvider<FavoriteProductsNotifier, List<String>>(
  (ref) {
    return FavoriteProductsNotifier();
  },
);
