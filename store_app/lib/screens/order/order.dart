import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:store_app/api/api_order.dart';
import 'package:store_app/data/delivery_method.dart';
import 'package:store_app/models/delivery_method.dart';
import 'package:store_app/models/shipping_address.dart';
import 'package:store_app/screens/order/detail_order.dart';
import 'package:store_app/screens/shipping/shipping_addresses.dart';
import 'package:store_app/screens/success/success.dart';
import 'package:store_app/utils/constants.dart';
import 'package:store_app/widgets/order/header_order.dart';
import 'package:store_app/widgets/order/price.dart';
import 'package:store_app/widgets/shipping/shipping_item.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });
  final double totalPrice;
  final List<PersistentShoppingCartItem> cartItems;

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  ShippingAddress? _shippingAddress;
  final ApiOrder _apiOrder = ApiOrder();

  bool _isCODSelected = true;
  bool _isCreditCardSelected = false;
  bool _noSelectPayment = false;
  bool _noSelectShippingAddress = false;

  var _paymentMethod = '';

  int _selectedDelivery = 0;
  DeliveryMethod _deliveryMethodChoose = dataDeliveryMethod[0];

  double _tax = 0;
  double _summary = 0;

  var _isAuthenticating = false;

  void _submitOrder() async {
    if (!_isCODSelected && !_isCreditCardSelected) {
      setState(() {
        _noSelectPayment = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please select the payment section',
            ),
          ),
        );
      }
    }
    if (_shippingAddress == null) {
      setState(() {
        _noSelectShippingAddress = true;
      });
      if (mounted) {
        //ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please select the shipping address section',
            ),
          ),
        );
      }
    }
    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_isCODSelected) _paymentMethod = 'COD';
      if (_isCreditCardSelected) _paymentMethod = 'CARD';

      final response = await _apiOrder.createOrder(
        _shippingAddress!,
        widget.cartItems,
        _paymentMethod,
        {
          'id': 'payment_id',
          'status': 'Not Paid',
        },
        widget.totalPrice,
        _tax,
        _deliveryMethodChoose,
        _summary,
      );
      print(response);
      PersistentShoppingCart().clearCart();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DetailOrderScreen(
            orderId: response['order']['_id'].toString(),
          ),
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SuccessScreen(
            text: 'Order Success',
          ),
        ),
      );
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
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final surface = Theme.of(context).colorScheme.surface;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    _tax = (widget.totalPrice + _deliveryMethodChoose.price) * 0.05;
    _summary = (widget.totalPrice + _deliveryMethodChoose.price + _tax);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primary,
        foregroundColor: onPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 12,
              ),
              const HeaderOrder(
                name: 'Shipping Address',
              ),
              _shippingAddress == null
                  ? InkWell(
                      onTap: () async {
                        final data = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ShippingAddressesScreen(
                              shippingAddresses: [],
                            ),
                          ),
                        );
                        if (data != null) {
                          setState(() {
                            _shippingAddress = data as ShippingAddress;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: _noSelectShippingAddress
                              ? BorderRadius.circular(12)
                              : null,
                          border: Border.all(
                            color:
                                _noSelectShippingAddress ? Colors.red : surface,
                            width: _noSelectShippingAddress ? 3.5 : 0.1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: surface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child:
                                  SvgPicture.asset('assets/icons/Parcel.svg'),
                            ),
                            const Spacer(),
                            Text(
                              'Add your shipping address',
                              style: TextStyle(
                                color: onSurface,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_ios,
                              //color: kTextColor,
                            )
                          ],
                        ),
                      ),
                    )
                  : ShippingItem(
                      shippingAddress: _shippingAddress!,
                      buttonString: 'Change',
                    ),
              const SizedBox(
                height: 12,
              ),
              const HeaderOrder(
                name: 'Promotion',
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  color: surface,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SvgPicture.asset('assets/icons/receipt.svg'),
                      ),
                      const Spacer(),
                      Text(
                        'Add voucher code',
                        style: TextStyle(
                          color: onSurface,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_ios,
                        //color: kTextColor,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const HeaderOrder(
                name: 'Payment',
              ),
              StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius:
                          _noSelectPayment ? BorderRadius.circular(12) : null,
                      border: Border.all(
                        color: _noSelectPayment ? Colors.red : surface,
                        width: _noSelectPayment ? 3.5 : 0.1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(10),
                            border: const Border.symmetric(
                              horizontal: BorderSide(
                                width: 0.1,
                              ),
                            ),
                          ),
                          child: CheckboxListTile(
                            tileColor: surface,
                            selectedTileColor: primary,
                            title: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              child: const Row(
                                children: [
                                  Icon(Icons.local_atm),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text('COD'),
                                ],
                              ),
                            ),
                            value: _isCODSelected,
                            onChanged: (value) {
                              setState(() {
                                _isCODSelected = value!;
                                if (value) {
                                  _isCreditCardSelected = false;
                                }
                              });
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(10),
                            border: const Border.symmetric(
                              horizontal: BorderSide(
                                width: 0.1,
                              ),
                            ),
                          ),
                          child: CheckboxListTile(
                            tileColor: surface,
                            title: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              child: const Row(
                                children: [
                                  Icon(Icons.credit_card),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text('Credit Card'),
                                ],
                              ),
                            ),
                            value: _isCreditCardSelected,
                            onChanged: (value) {
                              setState(() {
                                _isCreditCardSelected = value!;
                                if (value) {
                                  _isCODSelected = false;
                                }
                              });
                            },
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
              const HeaderOrder(
                name: 'Shipping Address',
              ),
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(12),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    mainAxisExtent: 150,
                  ),
                  itemCount: dataDeliveryMethod.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDelivery = index;
                          _deliveryMethodChoose = dataDeliveryMethod[index];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: kSecondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                _selectedDelivery == index ? primary : surface,
                            width: 3.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16),
                              ),
                              child: Image.asset(
                                dataDeliveryMethod[index].image,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: 90,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Center(
                              child: Text(
                                dataDeliveryMethod[index].duration,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                dataDeliveryMethod[index].name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const HeaderOrder(
                name: 'Price',
              ),
              PriceWidget(
                price: widget.totalPrice.toString(),
                typeOfPrice: 'Order: ',
              ),
              PriceWidget(
                price: _deliveryMethodChoose.price.toString(),
                typeOfPrice: 'Delivery: ',
              ),
              PriceWidget(
                price: _tax.toStringAsFixed(3),
                typeOfPrice: 'Tax: ',
              ),
              PriceWidget(
                price: _summary.toStringAsFixed(3),
                typeOfPrice: 'Summary: ',
                priceColor: Theme.of(context).colorScheme.error,
              ),
              if (_isAuthenticating)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if (!_isAuthenticating)
                Container(
                  height: 100,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: onPrimary,
                      ),
                      child: const Text('SUBMIT ORDER'),
                    ),
                  ),
                ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
