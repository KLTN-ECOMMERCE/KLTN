import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_app/api/api_order.dart';
import 'package:store_app/api/api_user.dart';
import 'package:store_app/api/api_voucher.dart';
import 'package:store_app/data/delivery_method.dart';
import 'package:store_app/models/delivery_method.dart';
import 'package:store_app/models/shipping_address.dart';
import 'package:store_app/notifications/notification_service.dart';
import 'package:store_app/screens/order/detail_order.dart';
import 'package:store_app/screens/promotion/voucher.dart';
import 'package:store_app/screens/shipping/shipping_addresses.dart';
import 'package:store_app/screens/success/success.dart';
import 'package:store_app/utils/constants.dart';
import 'package:store_app/widgets/order/header_order.dart';
import 'package:store_app/widgets/order/price.dart';
import 'package:store_app/widgets/shipping/shipping_item.dart';
import 'package:store_app/widgets/voucher/voucher_item.dart';

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
  dynamic _voucher;
  dynamic _profile;
  final ApiOrder _apiOrder = ApiOrder();
  final ApiUser _apiUser = ApiUser();
  final ApiVoucher _apiVoucher = ApiVoucher();
  NotificationService notificationService = NotificationService();

  bool _isCODSelected = true;
  bool _isCreditCardSelected = false;
  bool _noSelectPayment = false;
  bool _noSelectShippingAddress = false;
  bool _usePoint = false;

  var _paymentMethod = '';

  int _selectedDelivery = 0;
  DeliveryMethod _deliveryMethodChoose = dataDeliveryMethod[0];

  double _tax = 0;
  double _summary = 0;
  double _pointSale = 0;
  double _voucherSale = 0;
  double _shippingAmount = 0;

  var _isAuthenticating = false;

  Future<dynamic> _getUserProfile() async {
    try {
      final response = await _apiUser.getProfile();
      final profile = response['user'];
      _profile = profile;
      return profile;
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
        _shippingAmount,
      );
      print(response);
      PersistentShoppingCart().clearCart();
      if (_usePoint) {
        await _apiUser.updatePoint(0);
      }
      if (_voucher != null) {
        await _apiVoucher.userUseVoucher(_voucher['id']);
      }
      notificationService.showNotification(
        'Order ${response['order']['_id'].toString()}',
        'The order ${response['order']['_id'].toString()} will be confirmed by admin soon !!!',
        response['order']['_id'].toString(),
      );
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
  void initState() {
    _getUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final surface = Theme.of(context).colorScheme.surface;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    if (_usePoint) {
      _pointSale =
          (_profile == null) ? 0 : _profile['point'] * 0.02; // 2% point
    } else {
      _pointSale = 0;
    }

    if (_pointSale > widget.totalPrice) {
      _pointSale = widget.totalPrice;
    }

    _voucherSale = _voucher == null ? 0 : _voucher?['discount'] * 0.01;

    _shippingAmount = _voucher?['deliveryFee'].toString() == 'true'
        ? 0
        : _deliveryMethodChoose.price;

    _tax = (widget.totalPrice + _shippingAmount) * 0.05; // 5% tax

    _summary = ((widget.totalPrice - _pointSale) * (1 - _voucherSale) +
        _shippingAmount +
        _tax);

    Key shippingAddressKey = UniqueKey();
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
                            builder: (context) =>
                                const ShippingAddressesScreen(),
                          ),
                        );
                        if (data != null) {
                          setState(() {
                            _shippingAddress = data as ShippingAddress;
                          });
                        }
                      },
                      child: Container(
                        key: shippingAddressKey,
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
                      key: shippingAddressKey,
                      shippingAddress: _shippingAddress!,
                      buttonString: 'Change',
                      selectButton: (BuildContext context) async {
                        final data = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const ShippingAddressesScreen(),
                          ),
                        );
                        if (data != null) {
                          setState(() {
                            _shippingAddress = data as ShippingAddress;
                            shippingAddressKey =
                                Key(_shippingAddress!.id as String);
                          });
                        }
                      },
                    ),
              const SizedBox(
                height: 12,
              ),
              const HeaderOrder(
                name: 'Promotion',
              ),
              _voucher == null
                  ? InkWell(
                      onTap: () async {
                        final data = await showModalBottomSheet(
                          useSafeArea: true,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          )),
                          context: context,
                          builder: (context) => VoucherScreen(
                            typeOfPromotion: 'My Promotion',
                            onSelectVoucherItem: (
                              id,
                              description,
                              deliveryFee,
                              discount,
                            ) {
                              final data = {
                                'id': id,
                                'description': description,
                                'deliveryFee': deliveryFee,
                                'discount': discount,
                              };
                              Navigator.of(context).pop(data);
                            },
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width,
                            maxHeight: MediaQuery.of(context).size.height,
                          ),
                        );
                        setState(() {
                          _voucher = data;
                        });
                      },
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
                              child:
                                  SvgPicture.asset('assets/icons/receipt.svg'),
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
                    )
                  : VoucherItem(
                      id: _voucher['id'],
                      description: _voucher['description'],
                      deliveryFee: _voucher['deliveryFee'],
                      discount: _voucher['discount'],
                      typeOfPromotion: 'My Promotion',
                      isMargin: true,
                      onSelectVoucherItem: (
                        id,
                        description,
                        deliveryFee,
                        discount,
                      ) async {
                        final data = await showModalBottomSheet(
                          useSafeArea: true,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          )),
                          context: context,
                          builder: (context) => VoucherScreen(
                            typeOfPromotion: 'My Promotion',
                            onSelectVoucherItem: (
                              id,
                              description,
                              deliveryFee,
                              discount,
                            ) {
                              final data = {
                                'id': id,
                                'description': description,
                                'deliveryFee': deliveryFee,
                                'discount': discount,
                              };
                              Navigator.of(context).pop(data);
                            },
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width,
                            maxHeight: MediaQuery.of(context).size.height,
                          ),
                        );
                        setState(() {
                          _voucher = data;
                        });
                      },
                    ),
              const SizedBox(
                height: 12,
              ),
              const HeaderOrder(
                name: 'Point',
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
                child: SwitchListTile(
                  thumbIcon: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return const Icon(Icons.check);
                    }
                    return const Icon(Icons.close);
                  }),
                  title: Row(
                    children: [
                      if (!_usePoint)
                        Text(
                          'Use my point',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: onSurface,
                          ),
                        ),
                      if (_usePoint)
                        Shimmer.fromColors(
                          period: const Duration(
                            milliseconds: 800,
                          ),
                          baseColor: Colors.red,
                          highlightColor: Colors.purple,
                          direction: ShimmerDirection.ltr,
                          child: Text(
                            'My point: ${_profile['point']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  secondary: _usePoint
                      ? Shimmer.fromColors(
                          period: const Duration(
                            milliseconds: 800,
                          ),
                          baseColor: Colors.red,
                          highlightColor: Colors.purple,
                          direction: ShimmerDirection.ltr,
                          child: const Icon(
                            Icons.card_giftcard_outlined,
                          ),
                        )
                      : const Icon(
                          Icons.card_giftcard_outlined,
                          color: Colors.red,
                        ),
                  value: _usePoint,
                  onChanged: (value) {
                    setState(() {
                      _usePoint = value;
                    });
                  },
                  subtitle: _usePoint
                      ? null
                      : Text(
                          'After buying product, you can review the quality of product to receive reward point.',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: onSurface,
                          ),
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
                                  Text(
                                    'COD',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
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
                                  Text(
                                    'Credit Card',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
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
                price: '${widget.totalPrice.toString()} \$',
                typeOfPrice: 'Order: ',
              ),
              if (_profile != null && _usePoint)
                PriceWidget(
                  price: '- ${_pointSale.toString()} \$',
                  typeOfPrice: 'Use Point: ',
                  priceColor: Colors.red,
                ),
              if (_voucher != null)
                PriceWidget(
                  price: '- ${_voucherSale.toString()} %',
                  typeOfPrice: 'Voucher: ',
                  priceColor: Colors.red,
                ),
              PriceWidget(
                price: '${_shippingAmount.toString()} \$',
                typeOfPrice: 'Delivery: ',
              ),
              PriceWidget(
                price: '${_tax.toStringAsFixed(3)} \$',
                typeOfPrice: 'Tax: ',
              ),
              PriceWidget(
                price: '${_summary.toStringAsFixed(3)} \$',
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
