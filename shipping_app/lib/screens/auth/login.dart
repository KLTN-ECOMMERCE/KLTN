import 'package:flutter/material.dart';
import 'package:shipping_app/api/api_start.dart';
import 'package:shipping_app/components/custom_surfix_icon.dart';
import 'package:shipping_app/model/login.dart';
import 'package:shipping_app/screens/app.dart';
import 'package:shipping_app/screens/success/success.dart';
import 'package:shipping_app/utils/constants.dart';
import 'package:shipping_app/helper/keyboard.dart';

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

  final ApiStart _apiStart = ApiStart();

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
          builder: (context) => const AppScreen(
            currentIndex: 0,
          ),
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
                    'assets/images/add_address.jpg',
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return kPassNullError;
                          } else if (value.length < 6) {
                            return kShortPassError;
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
