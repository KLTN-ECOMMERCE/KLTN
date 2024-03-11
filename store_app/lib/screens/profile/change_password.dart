import 'package:flutter/material.dart';
import 'package:store_app/api/api_user.dart';
import 'package:store_app/components/custom_surfix_icon.dart';
import 'package:store_app/components/form_error.dart';
import 'package:store_app/helper/keyboard.dart';
import 'package:store_app/screens/success/success.dart';
import 'package:store_app/utils/constants.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() {
    return _ChangePasswordState();
  }
}

class _ChangePasswordState extends State<ChangePasswordScreen> {
  var _enteredOldPassword = '';
  var _enteredNewPassword = '';
  var _enteredConfirmPassword = '';
  final _formKey = GlobalKey<FormState>();
  var _isAuthenticating = false;
  //dynamic _responseChangePassword;
  var _hasMessage = false;
  var errorApi = '';
  final List<String?> errors = [];
  final ApiUser _apiUser = ApiUser();

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

  void _changePassword() async {
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
      await _apiUser.changePassword(
        _enteredOldPassword,
        _enteredNewPassword,
      );

      setState(() {
        _isAuthenticating = false;
      });
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SuccessScreen(
            text: 'Change Password Success',
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
        errorApi = e.toString();
        _isAuthenticating = false;
        _hasMessage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text(
              'CHANGE PASSWORD',
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
                      'Please, enter your old password and new password to change your password',
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
                            obscureText: true,
                            onSaved: (newValue) =>
                                _enteredOldPassword = newValue!,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                removeError(kPassNullError);
                              } else if (value.length >= 6) {
                                removeError(kShortPassError);
                              }
                              _enteredOldPassword = value;
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
                              fillColor: Theme.of(context).colorScheme.surface,
                              labelText: 'Old Password',
                              hintText: 'Enter your old password',
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: const CustomSurffixIcon(
                                svgIcon: 'assets/icons/Lock.svg',
                              ),
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
                            obscureText: true,
                            onSaved: (newValue) =>
                                _enteredNewPassword = newValue!,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                removeError(kPassNullError);
                              } else if (value.length >= 6) {
                                removeError(kShortPassError);
                              }
                              _enteredNewPassword = value;
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
                              fillColor: Theme.of(context).colorScheme.surface,
                              labelText: 'New Password',
                              hintText: 'Enter your new password',
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: const CustomSurffixIcon(
                                svgIcon: 'assets/icons/Lock.svg',
                              ),
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
                            obscureText: true,
                            onSaved: (newValue) =>
                                _enteredConfirmPassword = newValue!,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                removeError(kPassNullError);
                              } else if (value.isNotEmpty &&
                                  _enteredNewPassword ==
                                      _enteredConfirmPassword) {
                                removeError(kMatchPassError);
                              }
                              _enteredConfirmPassword = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                addError(kPassNullError);
                                return "";
                              } else if ((_enteredNewPassword != value)) {
                                addError(kMatchPassError);
                                return "";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                              labelText: 'Confirm Password',
                              hintText: 'Confirm your new password',
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: const CustomSurffixIcon(
                                svgIcon: 'assets/icons/Lock.svg',
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
                                errorApi,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.error),
                              ),
                            ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (!_isAuthenticating)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _changePassword,
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
        );
      },
    );
  }
}
