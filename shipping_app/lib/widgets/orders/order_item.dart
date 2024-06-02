import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shipping_app/api/api_shipper.dart';
import 'package:shipping_app/api/api_user.dart';
import 'package:shipping_app/data/status_color.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:shipping_app/screens/app.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({
    super.key,
    required this.orderId,
    required this.shippingId,
    required this.date,
    required this.quantity,
    required this.statusOrder,
    required this.totalAmount,
    required this.cashOnDelivery,
    required this.phoneNo,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.paymentMethod,
    required this.statusPayment,
    required this.userId,
    required this.orderItems,
  });
  final String orderId;
  final String shippingId;
  final String date;
  final String quantity;
  final double totalAmount;
  final String userId;
  final double cashOnDelivery;
  final String statusOrder;
  final String phoneNo;
  final String address;
  final String? latitude;
  final String? longitude;
  final String paymentMethod;
  final String statusPayment;
  final List orderItems;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  final ApiShipper _apiShipper = ApiShipper();
  @override
  Widget build(BuildContext context) {
    final ApiUser apiUser = ApiUser();

    Future<dynamic> _getUserInfo(String userId) async {
      try {
        final response = await apiUser.findUser(userId);
        return response;
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

    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(
        top: 12,
        bottom: 12,
        right: 8,
        left: 8,
      ),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 12,
          top: 12,
          right: 12,
          left: 12,
        ),
        child: FutureBuilder(
          future: _getUserInfo(
            widget.userId,
          ),
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
              final userData = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Shipping Code:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.shippingId,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
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
                      const Text(
                        'Cash On Delivery:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.cashOnDelivery.toStringAsFixed(2)}\$',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Center(
                    child: Text(
                      widget.address,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userData['name'].toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          widget.phoneNo,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order ${widget.orderId}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd').format(
                          DateTime.parse(widget.date),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.orderItems.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 300,
                              child: Text(
                                widget.orderItems[index]['name'].toString(),
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Text(
                              widget.orderItems[index]['quantity'].toString(),
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Payment Method: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            widget.paymentMethod,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.statusPayment,
                        style: TextStyle(
                          fontSize: 16,
                          color: statusColor[widget.statusPayment],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Quantity: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            widget.quantity,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          SizedBox(
                            width: 80,
                            child: Text(
                              '${widget.totalAmount.toStringAsFixed(2)}\$',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () async {
                            final finishedOrder = await showOkCancelAlertDialog(
                              context: context,
                              title: 'Are you sure?',
                              message:
                                  'Did you finish this order ? Please be sure this order has been delivered successfully. Thanks',
                              okLabel: 'Confirm',
                              defaultType: OkCancelAlertDefaultType.cancel,
                              isDestructiveAction: true,
                            );
                            if (finishedOrder == OkCancelResult.ok) {
                              try {
                                await _apiShipper
                                    .deliveredSucessfully(widget.orderId);
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      'You delivered this order successfully !!!',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const AppScreen(
                                      currentIndex: 1,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            'Completely',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: widget.longitude == null &&
                                  widget.latitude == null
                              ? null
                              : () async {
                                  final urlMap = Uri.parse(
                                      'https://www.google.com/maps?q=${widget.latitude},${widget.longitude}');

                                  if (await canLaunchUrl(urlMap)) {
                                    await launchUrl(urlMap);
                                  } else {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Can not open the map now !!!'),
                                      ),
                                    );
                                  }
                                },
                          child: Text(
                            'Direction',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        widget.statusOrder,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: statusColor[widget.statusOrder],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  BarcodeWidget(
                    data: '${widget.shippingId}${widget.orderId}',
                    drawText: false,
                    barcode: Barcode.code128(),
                    height: 50,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
