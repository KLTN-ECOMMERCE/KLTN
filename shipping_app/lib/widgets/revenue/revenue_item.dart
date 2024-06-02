import 'package:flutter/material.dart';

class RevenueItem extends StatelessWidget {
  const RevenueItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.number,
    required this.unit,
    required this.backgroundColor,
  });
  final String title;
  final String subtitle;
  final String number;
  final String unit;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: double.infinity,
      margin: const EdgeInsets.only(
        top: 8,
        bottom: 8,
        right: 8,
        left: 8,
      ),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 12,
          top: 12,
          right: 12,
          left: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Center(
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                maxLines: 3,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Center(
              child: Text(
                '$number $unit',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
