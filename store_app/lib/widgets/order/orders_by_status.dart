import 'dart:io';

import 'package:flutter/material.dart';
import 'package:store_app/api/api_order.dart';
import 'package:store_app/widgets/order/no_orders.dart';
import 'package:store_app/widgets/order/order_item.dart';

class OrdersByStatus extends StatefulWidget {
  const OrdersByStatus({
    super.key,
    required this.status,
  });
  final String status;

  @override
  State<OrdersByStatus> createState() => _OrdersByStatusState();
}

class _OrdersByStatusState extends State<OrdersByStatus> {
  final ApiOrder _apiOrder = ApiOrder();

  Future<List> _getOrdersByStatus(String status) async {
    try {
      final response = await _apiOrder.getOrdersByStatus(status);
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder(
              future: _getOrdersByStatus(widget.status),
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
                        final orderItems = orders[index]['orderItems'] as List;
                        num quantity = 0;
                        for (final item in orderItems) {
                          quantity = quantity + item['quantity'];
                        }
                        return OrderItem(
                          id: orders[index]['_id'].toString(),
                          date: orders[index]['createdAt'].toString(),
                          quantity: quantity.toString(),
                          statusOrder: orders[index]['orderStatus'].toString(),
                          totalAmount: orders[index]['totalAmount'].toDouble(),
                          paymentMethod:
                              orders[index]['paymentMethod'].toString(),
                          statusPayment:
                              orders[index]['paymentInfo']['status'].toString(),
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
    );
  }
}
