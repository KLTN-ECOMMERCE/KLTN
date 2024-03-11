import 'package:flutter/material.dart';

class MyProfileWidget extends StatelessWidget {
  const MyProfileWidget({
    super.key,
    required this.label,
    required this.information,
    required this.onTap,
  });
  final void Function(BuildContext context) onTap;
  final String label;
  final String information;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Theme.of(context).colorScheme.surface,
      ),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      height: 70,
      child: InkWell(
        onTap: () {
          onTap(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
              ),
            ),
            Row(
              children: [
                Text(
                  information,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
