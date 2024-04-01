import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_app/api/api_voucher.dart';

class VoucherItem extends StatefulWidget {
  const VoucherItem({
    super.key,
    required this.id,
    required this.description,
    required this.deliveryFee,
    required this.discount,
    required this.typeOfPromotion,
    this.onSelectVoucherItem,
    this.isMargin = false,
  });
  final String id;
  final String description;
  final String deliveryFee;
  final double discount;
  final String typeOfPromotion;
  final bool isMargin;
  final void Function(
    String id,
    String description,
    String deliveryFee,
    double discount,
  )? onSelectVoucherItem;

  @override
  State<VoucherItem> createState() => _VoucherItemState();
}

class _VoucherItemState extends State<VoucherItem> {
  final ApiVoucher _apiVoucher = ApiVoucher();
  var _isAuthenticating = false;

  void _userAddVoucher(String id) async {
    try {
      setState(() {
        _isAuthenticating = true;
      });
      final response = await _apiVoucher.userAddVoucher(id);
      setState(() {
        _isAuthenticating = false;
      });
      if (!mounted) return;
      await showOkAlertDialog(
        context: context,
        title: response.toString() != 'true' ? 'FAILURE' : 'SUCCESS',
        message: response.toString() != 'true'
            ? 'Failed to save voucher !'
            : 'Save voucher successfully !',
      );
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
      });
      if (!mounted) return;
      await showOkAlertDialog(
        context: context,
        title: 'FAILURE',
        message: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onSelectVoucherItem == null
          ? null
          : () {
              widget.onSelectVoucherItem!(
                widget.id,
                widget.description,
                widget.deliveryFee,
                widget.discount,
              );
            },
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: widget.isMargin == true
            ? null
            : const EdgeInsets.only(
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/8-sale-basket-1.png',
                    fit: BoxFit.fitHeight,
                    //height: 120,
                    width: 80,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Shimmer.fromColors(
                          period: const Duration(
                            milliseconds: 800,
                          ),
                          baseColor: Colors.orange,
                          highlightColor: Colors.green,
                          direction: ShimmerDirection.ltr,
                          child: Text(
                            widget.description,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 3,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Shimmer.fromColors(
                          period: const Duration(
                            milliseconds: 1000,
                          ),
                          baseColor: Colors.red,
                          highlightColor: Colors.lightBlue,
                          direction: ShimmerDirection.ltr,
                          child: Text(
                            'Discount: ${widget.discount.toString()}%',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        if (widget.deliveryFee == 'true')
                          Shimmer.fromColors(
                            period: const Duration(
                              milliseconds: 900,
                            ),
                            baseColor: Colors.orange,
                            highlightColor: Colors.green,
                            direction: ShimmerDirection.ltr,
                            child: const Text(
                              'FREE SHIP',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (widget.typeOfPromotion == 'Promotions')
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              _userAddVoucher(widget.id);
                            },
                            child: _isAuthenticating
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'ADD',
                                  ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              BarcodeWidget(
                data: widget.id,
                drawText: false,
                barcode: Barcode.code128(),
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
