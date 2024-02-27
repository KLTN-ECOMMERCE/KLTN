import 'package:flutter/material.dart';
import 'package:store_app/api/api_start.dart';
import 'package:store_app/components/custom_surfix_icon.dart';
import 'package:store_app/components/form_error.dart';
import 'package:store_app/constants.dart';
import 'package:store_app/helper/keyboard.dart';
import 'package:store_app/models/reset_password.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() {
    return _ResetPasswordState();
  }
}

class _ResetPasswordState extends State<ResetPasswordScreen> {
  var _enteredPassword = '';
  var _enteredConfirmPassword = '';
  var _enteredOtp = '';
  final _formKey = GlobalKey<FormState>();
  var _isAuthenticating = false;
  dynamic _responseResetPassword;
  var _hasMessage = false;
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

  void _resetPassword() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    KeyboardUtil.hideKeyboard(context);

    final data = ResetPassword(
      password: _enteredPassword,
      confirmPassword: _enteredConfirmPassword,
      otp: int.parse(_enteredOtp),
    );
    try {
      setState(() {
        _isAuthenticating = true;
      });
      _responseResetPassword = await _apiStart.resetPassword(data);
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
              'PASSWORD RECOVERY',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SizedBox(
            width: width,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Please, enter your OTP code and new password. If your OTP code is correct, your password will be changed',
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
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            obscureText: true,
                            onSaved: (newValue) => _enteredPassword = newValue!,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                removeError(kPassNullError);
                              } else if (value.length >= 6) {
                                removeError(kShortPassError);
                              }
                              _enteredPassword = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                addError(kPassNullError);
                                return "";
                              } else if (value.length < 6) {
                                addError(kShortPassError);
                                return "";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: surfaceColor,
                              labelText: "Password",
                              hintText: "Enter your password",
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: const CustomSurffixIcon(
                                svgIcon: "assets/icons/Lock.svg",
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            obscureText: true,
                            onSaved: (newValue) =>
                                _enteredConfirmPassword = newValue!,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                removeError(kPassNullError);
                              } else if (value.isNotEmpty &&
                                  _enteredPassword == _enteredConfirmPassword) {
                                removeError(kMatchPassError);
                              }
                              _enteredConfirmPassword = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                addError(kPassNullError);
                                return "";
                              } else if ((_enteredPassword != value)) {
                                addError(kMatchPassError);
                                return "";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: surfaceColor,
                              labelText: "Confirm Password",
                              hintText: "Confirm your password",
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: const CustomSurffixIcon(
                                svgIcon: "assets/icons/Lock.svg",
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
                                _responseResetPassword,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _resetPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                              ),
                              child: const Text(
                                'SUBMIT',
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
        );
      },
    );
  }
}
