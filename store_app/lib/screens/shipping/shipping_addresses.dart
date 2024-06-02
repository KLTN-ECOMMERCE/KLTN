import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:store_app/api/api_user.dart';
import 'package:store_app/models/place.dart';
import 'package:store_app/models/shipping_address.dart';
import 'package:store_app/screens/shipping/add_shipping_address.dart';
import 'package:store_app/widgets/shipping/shipping_item.dart';

class ShippingAddressesScreen extends StatefulWidget {
  const ShippingAddressesScreen({
    super.key,
  });

  @override
  State<ShippingAddressesScreen> createState() =>
      _ShippingAddressesScreenState();
}

class _ShippingAddressesScreenState extends State<ShippingAddressesScreen> {
  final ApiUser _apiUser = ApiUser();

  Future<List<dynamic>> _getShippingAddresses() async {
    try {
      final response = await _apiUser.getShippingAddresses();
      final addresses = response as List<dynamic>;
      return addresses;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
      throw HttpException(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var shippingAddressData = _getShippingAddresses();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shipping Addresses',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                shippingAddressData = _getShippingAddresses();
              });
            },
            icon: const Icon(
              Icons.refresh,
              //size: 30,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddShippingAddressScreen(),
            ),
          );
          setState(() {
            shippingAddressData = _getShippingAddresses();
          });
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(
              bottom: 20,
              top: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: shippingAddressData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                      );
                    } else {
                      final shippingAddresses = snapshot.data;
                      if (shippingAddresses == null ||
                          shippingAddresses.isEmpty) {
                        return const Center(
                          child: Text(
                            'No Shipping Address ...',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: shippingAddresses.length,
                          itemBuilder: (context, index) {
                            final countryCode = RegExp(r'\((.*?)\)')
                                .firstMatch(shippingAddresses[index]['country']
                                    .toString())
                                ?.group(1);
                            Country country =
                                CountryParser.parseCountryCode(countryCode!);
                            final shippingAddress = ShippingAddress(
                              id: shippingAddresses[index]['_id'].toString(),
                              address: shippingAddresses[index]['address']
                                  .toString(),
                              city: shippingAddresses[index]['city'].toString(),
                              country: country,
                              phoneNo: shippingAddresses[index]['phoneNo']
                                  .toString(),
                              zipCode: shippingAddresses[index]['zipCode']
                                  .toString(),
                              place: Place(
                                latitude: double.parse(
                                  shippingAddresses[index]['latitude'],
                                ),
                                longitude: double.parse(
                                  shippingAddresses[index]['longitude'],
                                ),
                              ),
                              isDefault: shippingAddresses[index]['isDefault'],
                            );
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ShippingItem(
                                shippingAddress: shippingAddress,
                                buttonString: 'Edit',
                                selectShippingItem: (ShippingAddress address) {
                                  Navigator.of(context).pop(address);
                                },
                                deleteShippingAddress: (shippingAddress) async {
                                  try {
                                    await _apiUser.deleteShippingAddress(
                                      shippingAddress.id as String,
                                    );
                                    setState(() {
                                      shippingAddressData =
                                          _getShippingAddresses();
                                    });
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(e.toString()),
                                        ),
                                      );
                                    }
                                    throw HttpException(e.toString());
                                  }
                                },
                                selectDefaultAdress: (shippingAddressId) async {
                                  try {
                                    final response = await _apiUser
                                        .updateDefaultShippingAddress(
                                      shippingAddressId,
                                    );
                                    setState(() {
                                      shippingAddressData =
                                          _getShippingAddresses();
                                    });
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(response.toString()),
                                      ),
                                    );
                                  } catch (e) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.toString()),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
