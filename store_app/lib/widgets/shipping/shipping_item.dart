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
    this.selectDefaultAdress,
  });
  final ShippingAddress shippingAddress;
  final String buttonString;
  final Function(ShippingAddress shippingAddress)? selectShippingItem;
  final Function(ShippingAddress shippingAddress)? deleteShippingAddress;
  final Function(BuildContext context)? selectButton;
  final Function(String shippingAddressId)? selectDefaultAdress;

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
    //Key key = UniqueKey();
    return Container(
      //key: key,
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
                  Expanded(
                    child: Text(
                      _shippingAddress.address,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
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
                                //key = data['key'] as Key;
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
                  Expanded(
                    child: Text(
                      '${_shippingAddress.city}, ${_shippingAddress.zipCode}, ${_shippingAddress.country.displayNameNoCountryCode}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
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
                height: 8,
              ),
              Text(
                _shippingAddress.phoneNo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              if (widget.selectDefaultAdress != null)
                CheckboxListTile(
                  selectedTileColor: Theme.of(context).colorScheme.primary,
                  value: _shippingAddress.isDefault,
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.not_listed_location_outlined),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Use as the shipping address',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  onChanged: (value) {
                    if (value == true) {
                      widget.selectDefaultAdress!(_shippingAddress.id!);
                      Navigator.of(context).pop(_shippingAddress);
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
