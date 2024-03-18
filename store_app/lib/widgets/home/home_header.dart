import 'package:flutter/material.dart';
import 'package:store_app/screens/app.dart';
import 'package:store_app/utils/constants.dart';
import 'package:store_app/widgets/home/search_field.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: SearchField(),
          ),
          const SizedBox(
            width: 4,
          ),
          PersistentShoppingCart().showCartItemCountWidget(
            cartItemCountWidgetBuilder: (itemCount) => IconButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  kSecondaryColor.withOpacity(0.1),
                ),
                iconSize: const MaterialStatePropertyAll(30),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const AppScreen(currentIndex: 1),
                  ),
                );
              },
              icon: Badge(
                label: itemCount != 0
                    ? Text(
                        itemCount.toString(),
                      )
                    : null,
                child: itemCount != 0
                    ? const Icon(
                        Icons.shopping_cart_rounded,
                      )
                    : const Icon(
                        Icons.shopping_cart_outlined,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
