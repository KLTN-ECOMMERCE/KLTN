import 'package:flutter/material.dart';
import 'package:store_app/api/api_start.dart';
import 'package:store_app/components/custom_surfix_icon.dart';
import 'package:store_app/components/form_error.dart';
import 'package:store_app/screens/success/success.dart';
import 'package:store_app/utils/constants.dart';
import 'package:store_app/helper/keyboard.dart';
import 'package:store_app/models/login.dart';
import 'package:store_app/screens/app.dart';
import 'package:store_app/screens/auth/forgot_password.dart';
import 'package:store_app/screens/auth/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginScreen> {
  var _isAuthenticating = false;

  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';

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

  void _login() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    KeyboardUtil.hideKeyboard(context);

    final data = Login(
      email: _enteredEmail,
      password: _enteredPassword,
    );

    try {
      setState(() {
        _isAuthenticating = true;
      });
      final responseLogin = await _apiStart.login(data);
      print(responseLogin);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AppScreen(),
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SuccessScreen(text: 'Login Success'),
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

  @override
  Widget build(BuildContext context) {
    Color surfaceColor = Theme.of(context).colorScheme.surface;
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN'),
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
                      const SizedBox(
                        height: 20,
                      ),
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
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: "Enter your password",
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
                      if (!_isAuthenticating)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            ),
                            child: const Text(
                              'LOGIN',
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
                          child: const Text(
                            'Forgotten Password?',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 85,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 2,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: const Text('Create new account'),
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
