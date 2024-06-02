import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shipping_app/api/api_stripe.dart';
import 'package:shipping_app/widgets/revenue/revenue_item.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.homeScrollController,
    required this.getUserProfile,
    required this.getOrdersByShippingUnit,
    required this.getShipper,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  final ScrollController homeScrollController;
  final Future<dynamic> Function() getUserProfile;
  final Future<List> Function() getOrdersByShippingUnit;
  final Future<dynamic> Function() getShipper;
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiStripe _apiStripe = ApiStripe();
  var _isAuthenticating = false;
  var totalAmount = 0.0;

  void _submitCOD(double totalAmount) async {
    try {
      setState(() {
        _isAuthenticating = true;
      });
      final response = await _apiStripe.createStripeCheckoutSessionShipper(
        totalAmount,
      );
      print(response);

      final url = Uri.parse(
        response['url'].toString(),
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url);

        await Future.delayed(
          const Duration(
            milliseconds: 100,
          ),
        );
        while (WidgetsBinding.instance.lifecycleState !=
            AppLifecycleState.resumed) {
          await Future.delayed(
            const Duration(
              milliseconds: 100,
            ),
          );
        }
        setState(() {
          _isAuthenticating = false;
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Can not open payment sheet now !!!'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
      });
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
        toolbarHeight: 100,
        title: FutureBuilder(
          future: widget.getUserProfile(),
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
              final profile = snapshot.data;
              return Row(
                children: [
                  CircleAvatar(
                    backgroundImage: profile['avatar'] == null
                        ? const AssetImage('assets/images/Profile Image.jpg')
                        : NetworkImage(
                            profile['avatar']['url'].toString(),
                          ) as ImageProvider,
                    radius: 50,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, ${profile['name'].toString()}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Your latest updates are below ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(
              Icons.refresh,
              size: 28,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: widget.homeScrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder(
                future: widget.getShipper(),
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
                    final shipper = snapshot.data;
                    totalAmount = double.parse(
                      shipper['totalPriceCOD'].toStringAsFixed(2),
                    );
                    return RevenueItem(
                      title: 'Cash on Delivery',
                      subtitle: 'The money that you must return to E-Shop',
                      number: shipper['totalPriceCOD'].toStringAsFixed(2),
                      unit: '\$',
                      backgroundColor: const Color.fromARGB(255, 228, 114, 248),
                    );
                  }
                },
              ),
              FutureBuilder(
                future: widget.getOrdersByShippingUnit(),
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
                    return RevenueItem(
                      title: 'Orders',
                      subtitle: 'Total number of orders to be delivered',
                      number: orders.length.toString(),
                      unit: '',
                      backgroundColor: const Color.fromARGB(255, 108, 201, 244),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              if (_isAuthenticating)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if (!_isAuthenticating)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final payCOD = await showOkCancelAlertDialog(
                        context: context,
                        title: 'Are you sure?',
                        message:
                            'You want to pay COD ?, Please be sure you want to pay your COD bill. Thanks',
                        okLabel: 'Comfirm',
                        defaultType: OkCancelAlertDefaultType.cancel,
                        isDestructiveAction: true,
                      );
                      if (payCOD == OkCancelResult.ok) {
                        _submitCOD(totalAmount);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      fixedSize: const Size(
                        200,
                        50,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.payment_outlined,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Pay COD',
                        ),
                      ],
                    ),
                  ),
                ),
              
            ],
          ),
        ),
      ),
    );
  }
}
