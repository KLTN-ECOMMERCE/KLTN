import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_app/components/form_error.dart';
import 'package:store_app/helper/keyboard.dart';
import 'package:store_app/models/shipping_address.dart';
import 'package:store_app/utils/constants.dart';
import 'package:country_picker/country_picker.dart';

class AddShippingAddressScreen extends StatefulWidget {
  const AddShippingAddressScreen({
    super.key,
    this.shippingAddress,
  });

  final ShippingAddress? shippingAddress;

  @override
  State<AddShippingAddressScreen> createState() =>
      _AddShippingAddressScreenState();
}

class _AddShippingAddressScreenState extends State<AddShippingAddressScreen> {
  Country country = CountryParser.parseCountryCode('VN');

  var _enteredFullName = '';
  var _enteredAddress = '';
  var _enteredCity = '';
  var _enteredPhoneNo = '';
  var _enteredZipCode = '';

  final List<String?> errors = [];
  final _formKey = GlobalKey<FormState>();

  void _showInitValue() {
    if (widget.shippingAddress != null) {
      _enteredFullName = widget.shippingAddress!.fullName;
      _enteredAddress = widget.shippingAddress!.address;
      _enteredCity = widget.shippingAddress!.city;
      _enteredPhoneNo = widget.shippingAddress!.phoneNo;
      _enteredZipCode = widget.shippingAddress!.zipCode;
      country = widget.shippingAddress!.country;
    }
  }

  void addError(String? error) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError(String? error) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _showInitValue();
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
          child: ElevatedButton(
            onPressed: () {
              final isValid = _formKey.currentState!.validate();
              if (!isValid) {
                return;
              }
              _formKey.currentState!.save();
              KeyboardUtil.hideKeyboard(context);
              final data = ShippingAddress(
                fullName: _enteredFullName,
                address: _enteredAddress,
                city: _enteredCity,
                country: country,
                phoneNo: _enteredPhoneNo,
                zipCode: _enteredZipCode,
              );
              Navigator.of(context).pop(data);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: onPrimary,
            ),
            child: const Text('ADD'),
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
                        keyboardType: TextInputType.name,
                        initialValue: _enteredFullName,
                        onSaved: (newValue) => _enteredFullName = newValue!,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            removeError(kNamelNullError);
                          }
                          if (!specialCharacters.hasMatch(value)) {
                            removeError(kSpecialCharactersNullError);
                          }
                          _enteredFullName = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            addError(kNamelNullError);
                            return "";
                          }
                          if (specialCharacters.hasMatch(value)) {
                            addError(kSpecialCharactersNullError);
                            return '';
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
                          labelText: "Full Name",
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: "Enter your full name",
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
                        initialValue: _enteredAddress,
                        onSaved: (newValue) => _enteredAddress = newValue!,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            removeError(kNullError);
                          }
                          if (!specialCharacters.hasMatch(value)) {
                            removeError(kSpecialCharactersNullError);
                          }
                          _enteredAddress = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            addError(kNullError);
                            return "";
                          }
                          if (specialCharacters.hasMatch(value)) {
                            addError(kSpecialCharactersNullError);
                            return '';
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
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            removeError(kNullError);
                          }
                          if (!specialCharacters.hasMatch(value)) {
                            removeError(kSpecialCharactersNullError);
                          }
                          _enteredCity = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            addError(kNullError);
                            return "";
                          }
                          if (specialCharacters.hasMatch(value)) {
                            addError(kSpecialCharactersNullError);
                            return '';
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
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            removeError(kNullError);
                          }
                          if (!specialCharacters.hasMatch(value)) {
                            removeError(kSpecialCharactersNullError);
                          }
                          _enteredPhoneNo = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            addError(kNullError);
                            return "";
                          }
                          if (specialCharacters.hasMatch(value)) {
                            addError(kSpecialCharactersNullError);
                            return '';
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
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            removeError(kNullError);
                          }
                          if (!specialCharacters.hasMatch(value)) {
                            removeError(kSpecialCharactersNullError);
                          }
                          _enteredZipCode = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            addError(kNullError);
                            return "";
                          }
                          if (specialCharacters.hasMatch(value)) {
                            addError(kSpecialCharactersNullError);
                            return '';
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
                      FormError(
                        errors: errors,
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
