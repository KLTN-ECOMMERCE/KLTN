import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewedProductsNotifier extends StateNotifier<List<String>> {
  ViewedProductsNotifier() : super([]);

  void toggleProductViewedStatus(String productId) {
    final productIsViewed = state.contains(productId);

    if (productIsViewed) {
      state.remove(productId);
    }
    state = [productId, ...state];
  }
}

final viewedProductsProvider =
    StateNotifierProvider<ViewedProductsNotifier, List<String>>(
  (ref) {
    return ViewedProductsNotifier();
  },
);
