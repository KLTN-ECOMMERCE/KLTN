import 'dart:io';

import 'package:flutter/material.dart';
import 'package:store_app/api/api_order.dart';
import 'package:store_app/screens/app.dart';
import 'package:store_app/widgets/order/order_item.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final List<String> tabs = [
    'Processing',
    'Shipped',
    'Delivered',
  ];
  final ApiOrder _apiOrder = ApiOrder();

  Future<List> _getOrders() async {
    try {
      final response = await _apiOrder.getOrders();
      final orders = response['orders'] as List;
      return orders;
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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Orders',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          bottom: TabBar(
            unselectedLabelColor: Colors.black54,
            labelColor: Theme.of(context).colorScheme.onPrimary,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 5,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            tabs: tabs
                .map(
                  (e) => Tab(
                    child: Text(
                      e,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        body: TabBarView(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder(
                      future: _getOrders(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
                          );
                        } else {
                          final orders = snapshot.data as List<dynamic>;
                          if (orders.isEmpty) {
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
                                    icon:
                                        const Icon(Icons.arrow_back_ios_sharp),
                                    label: const Text(
                                      'SHOP NOW',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        wordSpacing: 8,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: orders.length,
                              itemBuilder: (context, index) {
                                final orderItems =
                                    orders[index]['orderItems'] as List;
                                num quantity = 0;
                                for (final item in orderItems) {
                                  quantity = quantity + item['quantity'];
                                }
                                return OrderItem(
                                  id: orders[index]['_id'].toString(),
                                  date: orders[index]['createdAt'].toString(),
                                  quantity: quantity.toString(),
                                  statusOrder:
                                      orders[index]['orderStatus'].toString(),
                                  totalAmount:
                                      orders[index]['totalAmount'].toDouble(),
                                  paymentId: orders[index]['paymentInfo']['id']
                                      .toString(),
                                  statusPayment: orders[index]['paymentInfo']
                                          ['status']
                                      .toString(),
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
            Center(
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
            ),
            Center(
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
            ),
          ],
        ),
      ),
    );
  }
}
