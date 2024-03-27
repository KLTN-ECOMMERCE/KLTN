import 'package:flutter/material.dart';
import 'package:store_app/screens/app.dart';

class NoOrdersWidget extends StatelessWidget {
  const NoOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No orders in here ...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AppScreen(
                    currentIndex: 0,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back_ios_sharp),
            label: const Text(
              'SHOP NOW',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                wordSpacing: 8,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
