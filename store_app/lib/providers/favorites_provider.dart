import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteProductsNotifier extends StateNotifier<List<String>> {
  FavoriteProductsNotifier() : super([]);

  bool toggleProductFavoriteStatus(String productId) {
    final productIsFavorite = state.contains(productId);

    if (productIsFavorite) {
      state = state.where((element) => element != productId).toList();
      return false;
    } else {
      state = [...state, productId];
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
