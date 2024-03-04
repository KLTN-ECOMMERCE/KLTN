import 'package:flutter/material.dart';
import 'package:store_app/api/api_start.dart';
import 'package:store_app/components/custom_surfix_icon.dart';
import 'package:store_app/components/form_error.dart';
import 'package:store_app/utils/constants.dart';
import 'package:store_app/helper/keyboard.dart';
import 'package:store_app/screens/auth/reset_password.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() {
    return _ForgotPasswordState();
  }
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  var _enteredEmail = '';
  var _isAuthenticating = false;
  dynamic _responseForgotPassword;
  var _hasMessage = false;
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];

  final ApiStart _apiStart = ApiStart();

  void _openSubmitOTPOverlay(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => const ResetPasswordScreen(),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: (MediaQuery.of(context).size.height) / 1.5,
      ),
    );
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

  void _forgotPassword() async {
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
      _responseForgotPassword =
          await _apiStart.forgotPassword(_enteredEmail);
      if (!mounted) return;
      setState(() {
        _isAuthenticating = false;
        _hasMessage = true;
      });
      _openSubmitOTPOverlay(context);
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
              'FORGOT PASSWORD',
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
                        'Please, enter your email address. You will receive a OTP code to create a new password.',
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
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  removeError(kEmailNullError);
                                } else if (value.contains('@')) {
                                  removeError(kInvalidEmailError);
                                }
                                _enteredEmail = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  addError(kEmailNullError);
                                  return "";
                                } else if (!value.contains('@')) {
                                  addError(kInvalidEmailError);
                                  return "";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: surfaceColor,
                                labelText: "Email",
                                labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                                hintText: "Enter your email",
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
                                  _responseForgotPassword,
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
                                  onPressed: _forgotPassword,
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
