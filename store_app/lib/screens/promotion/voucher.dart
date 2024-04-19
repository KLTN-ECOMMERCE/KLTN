import 'dart:io';

import 'package:flutter/material.dart';
import 'package:store_app/api/api_user.dart';
import 'package:store_app/api/api_voucher.dart';
import 'package:store_app/widgets/voucher/voucher_item.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({
    super.key,
    required this.typeOfPromotion,
    this.onSelectVoucherItem,
  });
  final String typeOfPromotion;
  final void Function(
    String id,
    String name,
    int? quantity,
    String description,
    String deliveryFee,
    double discount,
  )? onSelectVoucherItem;

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  final ApiVoucher _apiVoucher = ApiVoucher();
  final ApiUser _apiUser = ApiUser();

  Future<List> _getAllVouchers() async {
    try {
      final response = await _apiVoucher.getAllVoucher();
      final vouchers = response as List;
      return vouchers;
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

  Future<List> _getVoucherOfUser() async {
    List listVoucher = [];
    try {
      final response = await _apiUser.getProfile();
      final profile = response['user'];
      final voucherId = profile['voucher'] as List;

      for (var id in voucherId) {
        final response = await _apiVoucher.getVoucherById(id);
        listVoucher.add(response);
      }
      return listVoucher;
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final vouchersOfUserData = _getVoucherOfUser();

    final allVouchersData = _getAllVouchers();

    Future<List<dynamic>> c = Future(() async {
      List<dynamic> listA = await vouchersOfUserData;
      List<dynamic> listB = await allVouchersData;

      return listB
          .where(
              (item) => !listA.any((element) => element['_id'] == item['_id']))
          .toList();
    });

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder(
              future: widget.typeOfPromotion == 'Promotions'
                  ? c
                  : vouchersOfUserData,
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
                  final vouchers = snapshot.data as List<dynamic>;
                  if (vouchers.isEmpty) {
                    return const Center(
                      child: Text(
                        'No vouchers in here ...',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: vouchers.length,
                      itemBuilder: (context, index) {
                        final voucher = vouchers[index] as Map<String, dynamic>;
                        return VoucherItem(
                          id: voucher['_id'].toString(),
                          name: voucher['name'].toString(),
                          description: voucher['description'].toString(),
                          deliveryFee: voucher['deliveryFee'].toString(),
                          discount: voucher['discount'].toDouble(),
                          quantity: widget.typeOfPromotion == 'Promotions'
                              ? voucher['quantity'].toInt()
                              : null,
                          typeOfPromotion: widget.typeOfPromotion,
                          onSelectVoucherItem: widget.onSelectVoucherItem,
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
