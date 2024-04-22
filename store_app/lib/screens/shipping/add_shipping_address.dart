import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_app/api/api_user.dart';
import 'package:store_app/helper/keyboard.dart';
import 'package:store_app/models/place.dart';
import 'package:store_app/models/shipping_address.dart';
import 'package:store_app/utils/constants.dart';
import 'package:country_picker/country_picker.dart';
import 'package:store_app/widgets/location/location_input.dart';

class AddShippingAddressScreen extends StatefulWidget {
  const AddShippingAddressScreen({
    super.key,
    this.shippingAddress,
    this.isUpdate = false,
  });

  final ShippingAddress? shippingAddress;
  final bool isUpdate;

  @override
  State<AddShippingAddressScreen> createState() =>
      _AddShippingAddressScreenState();
}

class _AddShippingAddressScreenState extends State<AddShippingAddressScreen> {
  Country country = CountryParser.parseCountryCode('VN');

  final TextEditingController _addressController = TextEditingController();
  var _enteredAddress = '';
  var _enteredCity = '';
  var _enteredPhoneNo = '';
  var _enteredZipCode = '';

  bool _isAuthenticating = false;
  Place? _selectedLocation;

  final _formKey = GlobalKey<FormState>();
  final ApiUser _apiUser = ApiUser();

  void _showInitValue() {
    if (widget.shippingAddress != null) {
      _addressController.text = widget.shippingAddress!.address;
      _enteredCity = widget.shippingAddress!.city;
      _enteredPhoneNo = widget.shippingAddress!.phoneNo;
      _enteredZipCode = widget.shippingAddress!.zipCode;
      _selectedLocation = widget.shippingAddress!.place;
      country = widget.shippingAddress!.country;
    }
  }

  void _addNewShippingAddress(ShippingAddress shippingAddress) async {
    try {
      setState(() {
        _isAuthenticating = true;
      });

      await _apiUser.addShippingAddress(shippingAddress);
      setState(() {
        _isAuthenticating = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void _updateShippingAddress(ShippingAddress shippingAddress) async {
    try {
      setState(() {
        _isAuthenticating = true;
      });

      await _apiUser.updateShippingAddress(shippingAddress);
      setState(() {
        _isAuthenticating = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _showInitValue();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final surface = Theme.of(context).colorScheme.surface;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shipping Addresses',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        width: double.infinity,
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(12),
          width: double.infinity,
          child: _isAuthenticating
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  onPressed: () {
                    final isValid = _formKey.currentState!.validate();
                    if (!isValid) {
                      return;
                    }
                    _formKey.currentState!.save();
                    KeyboardUtil.hideKeyboard(context);
                    if (_selectedLocation == null) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select location section !'),
                          ),
                        );
                      }
                      return;
                    }
                    final data = ShippingAddress(
                      id: widget.isUpdate ? widget.shippingAddress!.id : null,
                      address: _enteredAddress,
                      city: _enteredCity,
                      country: country,
                      phoneNo: _enteredPhoneNo,
                      zipCode: _enteredZipCode,
                      place: Place(
                        latitude: _selectedLocation!.latitude,
                        longitude: _selectedLocation!.longitude,
                      ),
                      isDefault: false,
                    );
                    widget.isUpdate
                        ? _updateShippingAddress(data)
                        : _addNewShippingAddress(data);
                    final popData = {
                      'shippingAddress': data,
                    };
                    Navigator.of(context).pop(
                      popData,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: onPrimary,
                  ),
                  child: Text(
                    widget.isUpdate ? 'UPDATE' : 'ADD',
                  ),
                ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/add_address.jpg',
                    fit: BoxFit.contain,
                    width: 250,
                    height: 200,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _addressController,
                        keyboardType: TextInputType.name,
                        //initialValue: _enteredAddress,
                        onSaved: (newValue) => _enteredAddress = newValue!,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return kNullError;
                          }
                          // if (specialCharacters.hasMatch(value)) {
                          //   return kSpecialCharactersNullError;
                          // }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            allowCharacters,
                          ),
                          // FilteringTextInputFormatter.deny(
                          //   specialCharacters,
                          // ),
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: surface,
                          labelText: "Address",
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: "Enter your Address",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        initialValue: _enteredCity,
                        onSaved: (newValue) => _enteredCity = newValue!,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return kNullError;
                          }
                          if (specialCharacters.hasMatch(value)) {
                            return kSpecialCharactersNullError;
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            allowCharacters,
                          ),
                          FilteringTextInputFormatter.deny(
                            specialCharacters,
                          ),
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: surface,
                          labelText: "City",
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: "Enter your City",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        initialValue: _enteredPhoneNo,
                        onSaved: (newValue) => _enteredPhoneNo = newValue!,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return kNullError;
                          }
                          if (specialCharacters.hasMatch(value)) {
                            return kSpecialCharactersNullError;
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            allowCharacters,
                          ),
                          FilteringTextInputFormatter.deny(
                            specialCharacters,
                          ),
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: surface,
                          labelText: "Phone Number",
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: "Enter your Phone Number",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          prefixIcon: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              showCountryPicker(
                                useSafeArea: true,
                                context: context,
                                countryListTheme: CountryListThemeData(
                                  bottomSheetHeight: 600,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(20),
                                  inputDecoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    hintText: 'Search your country here ...',
                                    border: InputBorder.none,
                                  ),
                                ),
                                onSelect: (value) {
                                  setState(() {
                                    country = value;
                                  });
                                },
                              );
                            },
                            child: Container(
                              height: 55,
                              width: 100,
                              alignment: Alignment.center,
                              child: Text(
                                '${country.flagEmoji} +${country.phoneCode}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: _enteredZipCode,
                        onSaved: (newValue) => _enteredZipCode = newValue!,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return kNullError;
                          }
                          if (specialCharacters.hasMatch(value)) {
                            return kSpecialCharactersNullError;
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            allowCharacters,
                          ),
                          FilteringTextInputFormatter.deny(
                            specialCharacters,
                          ),
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: surface,
                          labelText: "Zipcode",
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: "Enter your Zipcode",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (widget.isUpdate)
                        LocationInput(
                          location: widget.shippingAddress!.place,
                          onSelectLocation: (location) {
                            setState(() {
                              _selectedLocation = location;
                              _addressController.text =
                                  _selectedLocation!.address!;
                              _enteredAddress = _selectedLocation!.address!;
                            });
                          },
                        ),
                      if (!widget.isUpdate)
                        LocationInput(
                          onSelectLocation: (location) {
                            setState(() {
                              _selectedLocation = location;
                              _addressController.text =
                                  _selectedLocation!.address!;
                              _enteredAddress = _selectedLocation!.address!;
                            });
                          },
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
