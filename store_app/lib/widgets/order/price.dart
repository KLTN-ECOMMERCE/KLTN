import 'package:flutter/material.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    super.key,
    required this.price,
    required this.typeOfPrice,
    this.priceColor = Colors.black,
    this.textColor = Colors.black,
  });
  final String typeOfPrice, price;
  final Color priceColor, textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: const Border.symmetric(
          horizontal: BorderSide(
            width: 0.1,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              typeOfPrice,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 18,
                color: priceColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
