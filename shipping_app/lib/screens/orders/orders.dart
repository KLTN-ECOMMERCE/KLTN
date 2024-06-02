import 'package:flutter/material.dart';
import 'package:shipping_app/widgets/orders/no_orders.dart';
import 'package:shipping_app/widgets/orders/order_item.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    super.key,
    required this.getOrdersByShippingUnit,
    required this.homeScrollController,
  });

  final Future<List> Function() getOrdersByShippingUnit;
  final ScrollController homeScrollController;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    var ordersData = widget.getOrdersByShippingUnit();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                ordersData = widget.getOrdersByShippingUnit();
              });
            },
            icon: const Icon(
              Icons.refresh,
              size: 28,
            ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: widget.homeScrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder(
                future: ordersData,
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
                    final orders = snapshot.data as List<dynamic>;
                    if (orders.isEmpty) {
                      return const Center(
                        child: NoOrdersWidget(),
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
                            quantity += item['quantity'];
                          }
                          final address =
                              '${orders[index]['shippingInfo']['address'].toString()}, ${orders[index]['shippingInfo']['city'].toString()}, ${orders[index]['shippingInfo']['zipCode'].toString()}, ${orders[index]['shippingInfo']['country'].toString()}';
                          final cashOnDelivery =
                              orders[index]['paymentMethod'].toString() == 'COD'
                                  ? orders[index]['totalAmount'].toDouble()
                                  : 0.0;
                          return OrderItem(
                            orderId: orders[index]['_id'].toString(),
                            date: orders[index]['updatedAt'].toString(),
                            quantity: quantity.toString(),
                            statusOrder:
                                orders[index]['orderStatus'].toString(),
                            totalAmount:
                                orders[index]['totalAmount'].toDouble(),
                            paymentMethod:
                                orders[index]['paymentMethod'].toString(),
                            statusPayment: orders[index]['paymentInfo']
                                    ['status']
                                .toString(),
                            shippingId: orders[index]['shippingInfo']
                                    ['shipping']['code']
                                .toString(),
                            phoneNo: orders[index]['shippingInfo']['phoneNo']
                                .toString(),
                            latitude: orders[index]['shippingInfo']['latitude']
                                .toString(),
                            longitude: orders[index]['shippingInfo']
                                    ['longitude']
                                .toString(),
                            address: address,
                            cashOnDelivery: cashOnDelivery,
                            userId: orders[index]['user'].toString(),
                            orderItems: orderItems,
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
    );
  }
}
