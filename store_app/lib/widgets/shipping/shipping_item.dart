import 'package:flutter/material.dart';
import 'package:store_app/models/shipping_address.dart';
import 'package:store_app/screens/shipping/add_shipping_address.dart';

class ShippingItem extends StatefulWidget {
  const ShippingItem({
    super.key,
    required this.shippingAddress,
    required this.buttonString,
    this.selectShippingItem,
    this.selectButton,
    this.deleteShippingAddress,
  });
  final ShippingAddress shippingAddress;
  final String buttonString;
  final Function(ShippingAddress shippingAddress)? selectShippingItem;
  final Function(ShippingAddress shippingAddress)? deleteShippingAddress;
  final Function(BuildContext context)? selectButton;

  @override
  State<ShippingItem> createState() => _ShippingItemState();
}

class _ShippingItemState extends State<ShippingItem> {
  late ShippingAddress _shippingAddress;
  @override
  void initState() {
    super.initState();
    _shippingAddress = widget.shippingAddress;
  }

  @override
  Widget build(BuildContext context) {
    Key key = UniqueKey();
    return Container(
      key: key,
      clipBehavior: Clip.hardEdge,
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
          left: 30,
        ),
        child: InkWell(
          onTap: widget.selectShippingItem == null
              ? null
              : () {
                  widget.selectShippingItem!(_shippingAddress);
                },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _shippingAddress.address,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: widget.selectButton != null
                        ? () {
                            widget.selectButton!(context);
                          }
                        : () async {
                            final data = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddShippingAddressScreen(
                                  shippingAddress: _shippingAddress,
                                  isUpdate: true,
                                ),
                              ),
                            );
                            if (data != null) {
                              setState(() {
                                _shippingAddress =
                                    data['shippingAddress'] as ShippingAddress;
                                key = data['key'] as Key;
                              });
                            }
                          },
                    child: Text(
                      widget.buttonString,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_shippingAddress.city}, ${_shippingAddress.zipCode}, ${_shippingAddress.country.displayNameNoCountryCode}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (widget.deleteShippingAddress != null)
                    IconButton(
                      onPressed: () {
                        widget.deleteShippingAddress!(_shippingAddress);
                      },
                      icon: const Icon(Icons.delete_outline),
                    ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                _shippingAddress.phoneNo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
