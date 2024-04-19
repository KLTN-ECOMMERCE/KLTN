import 'package:flutter/material.dart';
import 'package:store_app/api/api_user.dart';
import 'package:store_app/components/custom_surfix_icon.dart';
import 'package:store_app/screens/profile/check_otp_new_email.dart';
import 'package:store_app/utils/constants.dart';
import 'package:store_app/helper/keyboard.dart';

class CheckOTPChangeEmailScreen extends StatefulWidget {
  const CheckOTPChangeEmailScreen({
    super.key,
    required this.message,
  });

  final String message;

  @override
  State<CheckOTPChangeEmailScreen> createState() {
    return _CheckOTPChangeEmailState();
  }
}

class _CheckOTPChangeEmailState extends State<CheckOTPChangeEmailScreen> {
  var _enteredOtp = '';
  var _isAuthenticating = false;
  final _formKey = GlobalKey<FormState>();
  dynamic _responseSendOtp;

  final ApiUser _apiUser = ApiUser();

  void _verify() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    KeyboardUtil.hideKeyboard(context);

    try {
      setState(() {
        _isAuthenticating = true;
      });

      final responseSendOtp = await _apiUser.checkOtpChangeEmail(
        int.parse(_enteredOtp),
      );

      _responseSendOtp = responseSendOtp;

      setState(() {
        _isAuthenticating = false;
      });
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CheckOTPNewEmailScreen(
            message: _responseSendOtp.toString(),
          ),
        ),
      );
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
                      Text(
                        widget.message.toString(),
                        style: const TextStyle(
                          fontSize: 18,
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
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return kOtpNullError;
                                } else if (value.length < 6) {
                                  return kInvalidOtpError;
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
                            const SizedBox(
                              height: 25,
                            ),
                            if (_isAuthenticating)
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                            if (!_isAuthenticating)
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
