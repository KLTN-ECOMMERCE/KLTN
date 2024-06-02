import 'package:flutter/material.dart';
import 'package:shipping_app/api/api_user.dart';
import 'package:shipping_app/components/custom_surfix_icon.dart';
import 'package:shipping_app/helper/keyboard.dart';
import 'package:shipping_app/screens/profile/check_otp_change_email.dart';
import 'package:shipping_app/utils/constants.dart';

// Undone
class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({
    super.key,
    required this.name,
  });
  final String name;

  @override
  State<ChangeEmailScreen> createState() {
    return _ChangeEmailState();
  }
}

class _ChangeEmailState extends State<ChangeEmailScreen> {
  var _enteredEmail = '';
  final _formKey = GlobalKey<FormState>();
  var _isAuthenticating = false;
  dynamic _responseChangeEmail;
  final ApiUser _apiUser = ApiUser();

  void _changeEmail() async {
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

      final response = await _apiUser.changeEmail(
        _enteredEmail,
        widget.name,
      );
      _responseChangeEmail = response;

      setState(() {
        _isAuthenticating = false;
      });
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CheckOTPChangeEmailScreen(
            message: _responseChangeEmail.toString(),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text(
              'CHANGE EMAIL',
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
                      'Please, enter your new email',
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
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (newValue) => _enteredEmail = newValue!,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return kEmailNullError;
                              } else if (!value.contains('@')) {
                                return kInvalidEmailError;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                              labelText: "Email",
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                              hintText: "Enter your new email",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: const CustomSurffixIcon(
                                svgIcon: "assets/icons/Mail.svg",
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
                                onPressed: _changeEmail,
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
