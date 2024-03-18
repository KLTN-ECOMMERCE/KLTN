import 'package:flutter/material.dart';

class HeaderOrder extends StatelessWidget {
  const HeaderOrder({
    super.key,
    required this.name,
  });
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
        top: 12,
        bottom: 4,
        right: 8,
        left: 8,
      ),
      margin: const EdgeInsets.only(
        top: 12,
        bottom: 4,
        right: 8,
        left: 8,
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
