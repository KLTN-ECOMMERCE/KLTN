import 'package:flutter/material.dart';
import 'package:store_app/models/shipping_address.dart';
import 'package:store_app/screens/shipping/add_shipping_address.dart';
import 'package:store_app/widgets/shipping/shipping_item.dart';

class ShippingAddressesScreen extends StatefulWidget {
  const ShippingAddressesScreen({
    super.key,
    required this.shippingAddresses,
  });
  final List<ShippingAddress>? shippingAddresses;

  @override
  State<ShippingAddressesScreen> createState() =>
      _ShippingAddressesScreenState();
}

class _ShippingAddressesScreenState extends State<ShippingAddressesScreen> {
  final List<ShippingAddress> _shippingAddresses = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shipping Addresses',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final data = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddShippingAddressScreen(),
            ),
          );
          if (data != null) {
            setState(() {
              _shippingAddresses.add(data as ShippingAddress);
            });
          }
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(
            bottom: 20,
            top: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.shippingAddresses!.isEmpty &&
                  _shippingAddresses.isEmpty)
                const Center(
                  child: Text(
                    'No Shipping Address ...',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              if (_shippingAddresses.isNotEmpty)
                //   // ListView.builder(
                //   //   shrinkWrap: true,
                //   //   itemCount: 1,
                //   //   itemBuilder: (context, index) {
                //   //     return ShippingItem(
                //   //       shippingAddress: _shippingAddresses![index],
                //   //       buttonString: 'Edit',
                //   //       selectShippingItem: () {
                //   //         Navigator.of(context).pop(
                //   //           _shippingAddresses![index]
                //   //         );
                //   //       },
                //   //     );
                //   //   },
                //   // ),
                ShippingItem(
                  shippingAddress: _shippingAddresses[0],
                  buttonString: 'Edit',
                  selectShippingItem: () {
                    Navigator.of(context).pop(
                      _shippingAddresses[0],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
