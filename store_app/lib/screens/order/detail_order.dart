import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:store_app/api/api_order.dart';
import 'package:store_app/data/status_color.dart';
import 'package:store_app/screens/app.dart';
import 'package:store_app/screens/order/order.dart';
import 'package:store_app/screens/review/review.dart';
import 'package:store_app/widgets/order/order_information.dart';
import 'package:shimmer/shimmer.dart';

class DetailOrderScreen extends StatefulWidget {
  const DetailOrderScreen({
    super.key,
    required this.orderId,
  });
  final String orderId;

  @override
  State<DetailOrderScreen> createState() => _DetailOrderScreenState();
}

class _DetailOrderScreenState extends State<DetailOrderScreen> {
  final ApiOrder _apiOrder = ApiOrder();
  var _isAuthenticating = false;

  Future<dynamic> _getOrderDetails(String orderId) async {
    try {
      final response = await _apiOrder.getOrderDetails(orderId);
      final order = response['order'];
      return order;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FutureBuilder(
                  future: _getOrderDetails(widget.orderId),
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
                      final order = snapshot.data as Map;
                      final orderItems = order['orderItems'] as List;
                      num quanity = 0;
                      for (final item in orderItems) {
                        quanity = quanity + item['quantity'];
                      }
                      return Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order ${order['_id'].toString()}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateFormat('yyyy-MM-dd').format(
                                    DateTime.parse(
                                      order['createdAt'].toString(),
                                    ),
                                  ),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Payment Code: ',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      order['paymentInfo']['id'].toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  order['paymentInfo']['status'].toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: statusColor[order['paymentInfo']
                                            ['status']
                                        .toString()],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Center(
                              child: Text(
                                order['orderStatus'].toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor[
                                      order['orderStatus'].toString()],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${quanity.toString()} items',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            if (order['orderStatus'].toString() == 'Delivered')
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Shimmer.fromColors(
                                      period: const Duration(
                                        milliseconds: 1000,
                                      ),
                                      baseColor: Colors.red,
                                      highlightColor: Colors.purple,
                                      direction: ShimmerDirection.ltr,
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Click product to review !!!',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Icon(
                                            Icons.arrow_downward_outlined,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: orderItems.length,
                              itemBuilder: (context, index) {
                                final totalPrice =
                                    double.parse(orderItems[index]['price']) *
                                        orderItems[index]['quantity'];
                                return Card(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  margin: const EdgeInsets.only(
                                    bottom: 12,
                                    top: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: InkWell(
                                    onTap: order['orderStatus'].toString() !=
                                            'Delivered'
                                        ? null
                                        : () {
                                            showModalBottomSheet(
                                              useSafeArea: true,
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(30),
                                                ),
                                              ),
                                              context: context,
                                              builder: (context) =>
                                                  ReviewScreen(
                                                productId: orderItems[index]
                                                        ['product']
                                                    .toString(),
                                              ),
                                              constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                maxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        1.3,
                                              ),
                                            );
                                          },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 4,
                                        top: 4,
                                        right: 8,
                                        left: 4,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.network(
                                            orderItems[index]['image'],
                                            fit: BoxFit.fitHeight,
                                            height: 140,
                                            width: 120,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  orderItems[index]['name'],
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondaryContainer,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Units: ',
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSurface,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          orderItems[index]
                                                                  ['quantity']
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Unit Price: ',
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSurface,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 85,
                                                          child: Text(
                                                            '${orderItems[index]['price'].toString()}\$',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            textAlign:
                                                                TextAlign.end,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/icons/Cash.svg',
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      '${totalPrice.toStringAsFixed(2)}\$',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.redAccent,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Order information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            OrderInformation(
                              title: 'Shipping Address: ',
                              information:
                                  '${order['shippingInfo']['address']}, ${order['shippingInfo']['city']}, ${order['shippingInfo']['zipCode']}, ${order['shippingInfo']['country']}',
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            OrderInformation(
                              title: 'Payment Method: ',
                              information: order['paymentMethod'],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            OrderInformation(
                              title: 'Delivery Method: ',
                              information:
                                  '${order['shippingInfo']['shippingUnit'].toString()}, ${order['shippingInfo']['shippingAmount'].toString()}\$',
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            OrderInformation(
                              title: 'Discount: ',
                              information: order['voucherInfo']['deliveryFee']
                                          .toString() ==
                                      'true'
                                  ? '${order['voucherInfo']['name'].toString()}, Sale: ${order['voucherInfo']['discount']}%, Free Ship !!!'
                                  : '${order['voucherInfo']['name'].toString()}, Sale: ${order['voucherInfo']['discount']}% !!!',
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            OrderInformation(
                              title: 'Total Amount: ',
                              information:
                                  '${order['totalAmount'].toStringAsFixed(2)}\$',
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            if (order['orderStatus'].toString() == 'NewOrder')
                              _isAuthenticating
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : ElevatedButton(
                                      onPressed: () async {
                                        var message = '';
                                        try {
                                          setState(() {
                                            _isAuthenticating = true;
                                          });
                                          final response =
                                              await _apiOrder.cancelOrder(
                                                  order['_id'].toString());
                                          message =
                                              response['success'].toString();
                                          setState(() {
                                            _isAuthenticating = false;
                                          });
                                        } catch (e) {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(context)
                                              .clearSnackBars();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(e.toString()),
                                            ),
                                          );
                                          setState(() {
                                            _isAuthenticating = false;
                                          });
                                        }
                                        if (!mounted) return;
                                        await showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) => Dialog(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              margin: const EdgeInsets.all(8),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  Text(
                                                    message == 'true'
                                                        ? 'Cancel Order Successfully'
                                                        : 'Fail to Cancel Order',
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      if (message == 'true') {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const AppScreen(
                                                              currentIndex: 3,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: const Text('Close'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).colorScheme.error,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onError,
                                      ),
                                      child: const SizedBox(
                                        height: 30,
                                        width: double.infinity,
                                        child: Center(
                                          child: Text(
                                            'Cancel Order',
                                          ),
                                        ),
                                      ),
                                    ),
                            if (order['orderStatus'].toString() == 'Delivered')
                              ElevatedButton(
                                onPressed: () {
                                  try {
                                    List<PersistentShoppingCartItem> cartItems =
                                        [];
                                    for (var item in orderItems) {
                                      cartItems.add(
                                        PersistentShoppingCartItem(
                                          productId: item['product'],
                                          productName: item['name'],
                                          unitPrice: double.parse(
                                                item['price'],
                                              ) /
                                              double.parse(
                                                item['quantity'].toString(),
                                              ),
                                          quantity: item['quantity'],
                                          productThumbnail: item['image'],
                                        ),
                                      );
                                    }
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return OrderScreen(
                                            cartItems: cartItems,
                                            totalPrice:
                                                order['itemsPrice'].toDouble(),
                                          );
                                        },
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                child: const SizedBox(
                                  height: 30,
                                  width: double.infinity,
                                  child: Center(
                                    child: Text(
                                      'Reorder',
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      );
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
