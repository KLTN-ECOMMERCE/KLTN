import 'package:flutter/material.dart';
import 'package:store_app/api/api_start.dart';
import 'package:store_app/components/custom_surfix_icon.dart';
import 'package:store_app/components/form_error.dart';
import 'package:store_app/utils/constants.dart';
import 'package:store_app/helper/keyboard.dart';
import 'package:store_app/models/send_otp.dart';

class SendOtpScreen extends StatefulWidget {
  const SendOtpScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<SendOtpScreen> createState() {
    return _SendOtpState();
  }
}

class _SendOtpState extends State<SendOtpScreen> {
  var _enteredOtp = '';
  var _isAuthenticating = false;
  final _formKey = GlobalKey<FormState>();
  var _hasMessage = false;
  dynamic _responseSendOtp;

  final List<String?> errors = [];

  final ApiStart _apiStart = ApiStart();

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

  void _verify() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    KeyboardUtil.hideKeyboard(context);

    final data = SendOTP(
      email: widget.email,
      otp: int.parse(_enteredOtp),
    );
    try {
      setState(() {
        _isAuthenticating = true;
      });
      final responseSendOtp = await _apiStart.sendOtp(data);
      _responseSendOtp = responseSendOtp;
      setState(() {
        _isAuthenticating = false;
        _hasMessage = true;
      });
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
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
        _hasMessage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text(
              'VERIFY',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SafeArea(
            child: SizedBox(
              width: width,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Please, enter your OTP which sent to your email',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              maxLength: 6,
                              keyboardType: TextInputType.number,
                              onSaved: (newValue) => _enteredOtp = newValue!,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  removeError(kOtpNullError);
                                } else if (value.length == 6) {
                                  removeError(kInvalidOtpError);
                                }
                                _enteredOtp = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  addError(kOtpNullError);
                                  return "";
                                } else if (value.length < 6) {
                                  addError(kInvalidOtpError);
                                  return "";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: surfaceColor,
                                labelText: 'OTP Code',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: const CustomSurffixIcon(
                                  svgIcon: "assets/icons/Lock.svg",
                                ),
                                hintText: "Enter your OTP code",
                                labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                            FormError(
                              errors: errors,
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            if (_isAuthenticating)
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                            if (_hasMessage)
                              Center(
                                child: Text(
                                  _responseSendOtp['message'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ),
                            if (!_isAuthenticating && !_hasMessage)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _verify,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    foregroundColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  child: const Text(
                                    'SEND',
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
