import 'package:flutter/material.dart';
import 'package:store_app/api/api_start.dart';
import 'package:store_app/components/custom_surfix_icon.dart';
import 'package:store_app/components/form_error.dart';
import 'package:store_app/constants.dart';
import 'package:store_app/helper/keyboard.dart';
import 'package:store_app/models/register.dart';
import 'package:store_app/screens/auth/forgot_password.dart';
import 'package:store_app/screens/auth/send_otp.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() {
    return _SignupState();
  }
}

class _SignupState extends State<SignupScreen> {
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredConfirmPassword = '';
  var _enteredName = '';

  final List<String?> errors = [];

  final _formKey = GlobalKey<FormState>();
  var _isAuthenticating = false;
  dynamic _responseRegister;
  var _hasMessage = false;

  final ApiStart _apiStart = ApiStart();

  @override
  void dispose() {
    super.dispose();
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

  void _openForgotPasswordOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => const ForgotPasswordScreen(),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: (MediaQuery.of(context).size.height) / 1.3,
      ),
    );
  }

  void _openSendOTPOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => SendOtpScreen(email: _enteredEmail),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: (MediaQuery.of(context).size.height) / 1.3,
      ),
    );
  }

  void _register() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    KeyboardUtil.hideKeyboard(context);
    
    final data = Register(
      email: _enteredEmail,
      password: _enteredPassword,
      name: _enteredName,
    );
    try {
      setState(() {
        _isAuthenticating = true;
      });
      final responseRegister = await _apiStart.register(data);
      _responseRegister = responseRegister;
      setState(() {
        _isAuthenticating = false;
        _hasMessage = true;
      });
      _openSendOTPOverlay();
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
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIGN UP'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        titleTextStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
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
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    width: 300,
                    height: 250,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.name,
                        onSaved: (newValue) => _enteredName = newValue!,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            removeError(kNamelNullError);
                          }
                          _enteredName = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            addError(kNamelNullError);
                            return "";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: surfaceColor,
                          labelText: "Name",
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: "Enter your name",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: const CustomSurffixIcon(
                            svgIcon: "assets/icons/User Icon.svg",
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
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: "Enter your email",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        onSaved: (newValue) => _enteredConfirmPassword = newValue!,
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
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                            _responseRegister,
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
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            ),
                            child: const Text(
                              'SIGN UP',
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: TextButton(
                          onPressed: _openForgotPasswordOverlay,
                          style: TextButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.onBackground),
                          child: const Text('Forgotten Password?'),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 2,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: const Text('Already have an account'),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
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
