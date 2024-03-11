import 'package:flutter/material.dart';

class SortItemWidget extends StatelessWidget {
  const SortItemWidget({
    super.key,
    required this.typeOfSort,
    required this.icon,
  });
  final String typeOfSort;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStatePropertyAll(
        Theme.of(context).colorScheme.secondary,
      ),
      onTap: () {
        Navigator.of(context).pop(typeOfSort);
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              typeOfSort,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            Icon(
              icon,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
